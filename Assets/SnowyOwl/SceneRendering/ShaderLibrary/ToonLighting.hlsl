#ifndef SNOWYOWL_TOON_LIGHTING_INCLUDED
#define SNOWYOWL_TOON_LIGHTING_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Assets/SnowyOwl/SceneRendering/Shaders/ToonLitInput.hlsl"

CustomLightData CreateCustomLightData(Light light, InputData inputData)
{
    CustomLightData lightData = (CustomLightData)0;

    half3 halfDir = SafeNormalize(light.direction + inputData.viewDirectionWS);

    lightData.lightColor = light.color;
    lightData.lightDir = light.direction;
    lightData.distanceAttenuation = light.distanceAttenuation;
    lightData.shadowAttenuation = light.shadowAttenuation;
    lightData.NdotL = dot(inputData.normalWS, light.direction);
    lightData.NdotV = saturate(dot(inputData.normalWS, inputData.viewDirectionWS));
    lightData.NdotH = saturate(dot(inputData.normalWS, halfDir));
    lightData.LdotH = saturate(dot(light.direction, halfDir));

    return lightData;
}

///////////////////////////////////////////////////////////////////////////////
//                      Lighting Functions                                   //
///////////////////////////////////////////////////////////////////////////////
half3 ToonLightingDiffuse(CustomLightData lightData, half3 brightColor, half3 darkenColor, float diffuseRadiance)
{
    return lerp(darkenColor, brightColor, diffuseRadiance);
}

half3 ToonLightingSpecular(CustomLightData lightData, ToonSurfaceData toonSurfaceData, half3 brightColor, float diffuseRadiance)
{
#if defined(_SPECULARHIGHLIGHTS_OFF)
    return half3(0, 0, 0);
#endif
    half3 specularColor = lerp(brightColor, toonSurfaceData.customSpecularColor, toonSurfaceData.customSpecularColorWeight);
    specularColor *= step(0.2f, toonSurfaceData.specularScale * pow(lightData.NdotH, toonSurfaceData.smoothness));
    return lerp(half3(0, 0, 0), specularColor, diffuseRadiance);
}

half3 ToonDirectLighting(Light light, InputData inputData, ToonSurfaceData toonSurfaceData, half isMainLight = 0)
{
    CustomLightData lightData = CreateCustomLightData(light, inputData);

    half3 brightColor = lightData.lightColor * toonSurfaceData.albedo;
	half3 darkenColor = lightData.lightColor * toonSurfaceData.albedo * toonSurfaceData.shadowColor;

    half halfLambert = lightData.NdotL * 0.5 + 0.5;
    float diffuseRadiance = halfLambert * lightData.shadowAttenuation * (toonSurfaceData.shadowThreshold * 2);
    diffuseRadiance = saturate(1 + (diffuseRadiance - 0.5 - 0) / max(0, 1e-5));

    half3 toonDirectLighting = 0;
    toonDirectLighting += ToonLightingDiffuse(lightData, brightColor, darkenColor, diffuseRadiance);
    toonDirectLighting += ToonLightingSpecular(lightData, toonSurfaceData, brightColor, diffuseRadiance);

    toonDirectLighting = lerp(half3(0, 0, 0), toonDirectLighting, lightData.distanceAttenuation);

    return toonDirectLighting;
}



// ---------------------
LightAccumulator CreateLightAccumulator(InputData inputData, ToonSurfaceData toonSurfaceData)
{
    LightAccumulator lightAccumulator;

    lightAccumulator.mainLightColor = 0;
    lightAccumulator.additionalLightsColor = 0;
    lightAccumulator.vertexLightingColor = 0;

    lightAccumulator.giColor = inputData.bakedGI * toonSurfaceData.giScale;
    lightAccumulator.emissionColor = toonSurfaceData.emissionColor;

    return lightAccumulator;
}

half3 AccumulateLighting(LightAccumulator lightAccumulator, half3 albedo)
{
    half3 lightingAccumulation = 0;
    if (IsOnlyAOLightingFeatureEnabled())
    {
        return lightAccumulator.giColor; // Contains white + AO
    }

    if (IsLightingFeatureEnabled(DEBUGLIGHTINGFEATUREFLAGS_GLOBAL_ILLUMINATION))
    {
        lightingAccumulation += lightAccumulator.giColor * albedo;
    }

    if (IsLightingFeatureEnabled(DEBUGLIGHTINGFEATUREFLAGS_MAIN_LIGHT))
    {
        lightingAccumulation += lightAccumulator.mainLightColor;
    }

    if (IsLightingFeatureEnabled(DEBUGLIGHTINGFEATUREFLAGS_ADDITIONAL_LIGHTS))
    {
        lightingAccumulation += lightAccumulator.additionalLightsColor;
    }

    if (IsLightingFeatureEnabled(DEBUGLIGHTINGFEATUREFLAGS_VERTEX_LIGHTING))
    {
        lightingAccumulation += lightAccumulator.vertexLightingColor;
    }

    if (IsLightingFeatureEnabled(DEBUGLIGHTINGFEATUREFLAGS_EMISSION))
    {
        lightingAccumulation += lightAccumulator.emissionColor;
    }

    return lightingAccumulation;
}

half4 FinalColorOutput(LightAccumulator lightAccumulator, half3 albedo, half alpha)
{
    half3 finalColor = AccumulateLighting(lightAccumulator, albedo);
    return half4(finalColor, alpha);
}

////////////////////////////////////////////////////////////////////////////////
/// SnowyOwl ToonShading
////////////////////////////////////////////////////////////////////////////////
half4 SnowyOwl_ToonShading(InputData inputData, ToonSurfaceData toonSurfaceData)
{   
    uint meshRenderingLayers = GetMeshRenderingLayer();
    Light mainLight = GetMainLight(inputData.shadowCoord);

    LightAccumulator lightAccumulator = CreateLightAccumulator(inputData, toonSurfaceData);

    if (IsMatchingLightLayer(mainLight.layerMask, meshRenderingLayers))
    {
        lightAccumulator.mainLightColor += ToonDirectLighting(mainLight, inputData, toonSurfaceData, 1);
    }

#if defined(_ADDITIONAL_LIGHTS)
    uint pixelLightCount = GetAdditionalLightsCount();

    #if USE_CLUSTERED_LIGHTING
    for (uint lightIndex = 0; lightIndex < min(_AdditionalLightsDirectionalCount, MAX_VISIBLE_LIGHTS); lightIndex++)
    {
        Light light = GetAdditionalLight(lightIndex, inputData.positionWS);

        if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
        {
            lightAccumulator.additionalLightsColor += ToonDirectLighting(light, inputData, toonSurfaceData, 0);
        }
    }
    #endif

    LIGHT_LOOP_BEGIN(pixelLightCount)
        Light light = GetAdditionalLight(lightIndex, inputData.positionWS);
        if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
        {
            lightAccumulator.additionalLightsColor += ToonDirectLighting(light, inputData, toonSurfaceData, 0);
        }
    LIGHT_LOOP_END
#endif

    return FinalColorOutput(lightAccumulator, toonSurfaceData.albedo, toonSurfaceData.alpha);
}

#endif // SNOWYOWL_TOON_LIGHTING_INCLUDE