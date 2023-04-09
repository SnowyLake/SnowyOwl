#ifndef SNOWYOWL_TOON_LIGHTING_INCLUDED
#define SNOWYOWL_TOON_LIGHTING_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Assets/OwlPackage/ToonShading/Shaders/ToonLitInput.hlsl"

///////////////////////////////////////////////////////////////////////////////
//                      Lighting Functions                                   //
///////////////////////////////////////////////////////////////////////////////
half3 ToonLightingDiffuse(Light light, half3 brightColor, half3 shadowColor, half isShadow)
{
    return light.color * lerp(brightColor, shadowColor, isShadow);
}

half3 ToonLightingSpecular(Light light, InputData inputData, ToonSurfaceData toonSurfaceData, half3 brightColor, half isShadow)
{
#if defined(_SPECULARHIGHLIGHTS_OFF)
    return half3(0, 0, 0);
#endif

    half NdotH = half(saturate(dot(inputData.normalWS, SafeNormalize(float3(light.direction) + float3(inputData.viewDirectionWS)))));
    half3 specularColor = lerp(light.color * brightColor, toonSurfaceData.customSpecularColor, toonSurfaceData.customSpecularColorWeight);
    specularColor *= step(0.2f, toonSurfaceData.specularScale * pow(NdotH, toonSurfaceData.smoothness));
    return lerp(specularColor, half3(0, 0, 0), isShadow);
}

half3 ToonDirectLighting(Light light, InputData inputData, ToonSurfaceData toonSurfaceData, half isMainLight = 0)
{
    half3 brightColor = toonSurfaceData.albedo;
	half3 shadowColor = toonSurfaceData.albedo * toonSurfaceData.shadowColor;

    half NdotL = saturate(dot(inputData.normalWS, light.direction));
    half isShadow = step(NdotL * light.shadowAttenuation, toonSurfaceData.shadowThreshold);

    half3 toonDirectLighting = 0;
    toonDirectLighting += ToonLightingDiffuse(light, brightColor, shadowColor, isShadow);
    toonDirectLighting += ToonLightingSpecular(light, inputData, toonSurfaceData, brightColor, isShadow);

    toonDirectLighting = lerp(half3(0, 0, 0), toonDirectLighting, light.distanceAttenuation);

    return toonDirectLighting;
}

struct ToonLightingData
{
    half3 giColor;
    half3 mainLightColor;
    half3 additionalLightsColor;
    half3 vertexLightingColor;
    half3 emissionColor;
};

ToonLightingData CreateToonLightingData(InputData inputData, ToonSurfaceData toonSurfaceData)
{
    ToonLightingData toonLightingData;

    toonLightingData.giColor = inputData.bakedGI * toonSurfaceData.giScale;
    toonLightingData.emissionColor = toonSurfaceData.emissiveColor;
    toonLightingData.vertexLightingColor = 0;
    toonLightingData.mainLightColor = 0;
    toonLightingData.additionalLightsColor = 0;

    return toonLightingData;
}

half3 CalculateToonLightingColor(ToonLightingData toonLightingData, half3 albedo)
{
    half3 lightingColor = 0;
    if (IsOnlyAOLightingFeatureEnabled())
    {
        return toonLightingData.giColor; // Contains white + AO
    }

    if (IsLightingFeatureEnabled(DEBUGLIGHTINGFEATUREFLAGS_GLOBAL_ILLUMINATION))
    {
        lightingColor += toonLightingData.giColor * albedo;
    }

    if (IsLightingFeatureEnabled(DEBUGLIGHTINGFEATUREFLAGS_MAIN_LIGHT))
    {
        lightingColor += toonLightingData.mainLightColor;
    }

    if (IsLightingFeatureEnabled(DEBUGLIGHTINGFEATUREFLAGS_ADDITIONAL_LIGHTS))
    {
        lightingColor += toonLightingData.additionalLightsColor;
    }

    if (IsLightingFeatureEnabled(DEBUGLIGHTINGFEATUREFLAGS_VERTEX_LIGHTING))
    {
        lightingColor += toonLightingData.vertexLightingColor;
    }

    if (IsLightingFeatureEnabled(DEBUGLIGHTINGFEATUREFLAGS_EMISSION))
    {
        lightingColor += toonLightingData.emissionColor;
    }

    return lightingColor;
}

half4 CalculateToonFinalColor(ToonLightingData toonLightingData, half3 albedo, half alpha)
{
    half3 finalColor = CalculateToonLightingColor(toonLightingData, albedo);
    return half4(finalColor, alpha);
}

////////////////////////////////////////////////////////////////////////////////
/// Owl ToonShading
////////////////////////////////////////////////////////////////////////////////
half4 OwlToonShadingFragment(InputData inputData, ToonSurfaceData toonSurfaceData)
{   
    uint meshRenderingLayers = GetMeshRenderingLightLayer();
    Light mainLight = GetMainLight(inputData.shadowCoord);

    ToonLightingData toonLightingData = CreateToonLightingData(inputData, toonSurfaceData);

    if (IsMatchingLightLayer(mainLight.layerMask, meshRenderingLayers))
    {
        toonLightingData.mainLightColor += ToonDirectLighting(mainLight, inputData, toonSurfaceData, 1);
    }

#if defined(_ADDITIONAL_LIGHTS)
    uint pixelLightCount = GetAdditionalLightsCount();

    #if USE_CLUSTERED_LIGHTING
    for (uint lightIndex = 0; lightIndex < min(_AdditionalLightsDirectionalCount, MAX_VISIBLE_LIGHTS); lightIndex++)
    {
        Light light = GetAdditionalLight(lightIndex, inputData.positionWS);

        if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
        {
            toonLightingData.additionalLightsColor += ToonDirectLighting(light, inputData, toonSurfaceData, 0);
        }
    }
    #endif

    LIGHT_LOOP_BEGIN(pixelLightCount)
        Light light = GetAdditionalLight(lightIndex, inputData.positionWS);
        if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
        {
            toonLightingData.additionalLightsColor += ToonDirectLighting(light, inputData, toonSurfaceData, 0);
        }
    LIGHT_LOOP_END
#endif

    return CalculateToonFinalColor(toonLightingData, toonSurfaceData.albedo, toonSurfaceData.alpha);
}

#endif // SNOWYOWL_TOON_LIGHTING_INCLUDE