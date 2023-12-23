#ifndef SNOWYOWL_TOON_LIGHTING_INCLUDED
#define SNOWYOWL_TOON_LIGHTING_INCLUDED

#include "ToonLightingData.hlsl"
#include "CommonLighting.hlsl"

// ---------------------
LightAccumulator CreateLightAccumulator(InputData inputData, ToonLitSurfaceData toonSurfaceData)
{
    LightAccumulator lightAccumulator = (LightAccumulator)0;

    lightAccumulator.mainLightColor = 0;
    lightAccumulator.additionalLightsColor = 0;
    lightAccumulator.vertexLightingColor = 0;

    lightAccumulator.giColor = inputData.bakedGI * toonSurfaceData.giScale;
    lightAccumulator.emissionColor = toonSurfaceData.emissionColor;

    return lightAccumulator;
}

// TODO: SSS
CustomLightData CreateCustomLightData(Light light, InputData inputData)
{
    CustomLightData lightData = (CustomLightData)0;

    half3 halfDir = SafeNormalize(light.direction + inputData.viewDirectionWS);

    lightData.lightColor = light.color;
    lightData.lightDir = light.direction;
    lightData.distanceAttenuation = light.distanceAttenuation;
    lightData.shadowAttenuation = light.shadowAttenuation;
    lightData.NdotL = dot(inputData.normalWS, light.direction);
    lightData.NdotV = dot(inputData.normalWS, inputData.viewDirectionWS);
    lightData.NdotH = dot(inputData.normalWS, halfDir);
    lightData.LdotH = dot(light.direction, halfDir);

    return lightData;
}

///////////////////////////////////////////////////////////////////////////////
//                      Lighting Functions                                   //
///////////////////////////////////////////////////////////////////////////////
half ToonLightingDiffuse(CustomLightData lightData, InputData inputData, ToonLitSurfaceData toonSurfaceData)
{
    half diffuseStepOffset = saturate(toonSurfaceData.shadowThreshold * 2 - 1);
    half diffuseStepSmoothnessBias = toonSurfaceData.diffuseStepSmoothness * rcp(2) * (1 - toonSurfaceData.diffuseStepSmoothnessOffset);
    half diffuseRadiance = saturate(lightData.NdotL + diffuseStepOffset + diffuseStepSmoothnessBias + 0.01);
    diffuseRadiance = smoothstep(saturate(0.01 - toonSurfaceData.diffuseStepSmoothness),
                                 saturate(0.01 + toonSurfaceData.diffuseStepSmoothness),
                                 diffuseRadiance);
    return diffuseRadiance;
}

half3 ToonLightingSpecular(CustomLightData lightData, ToonLitSurfaceData toonSurfaceData, half3 brightColor, float diffuseRadiance)
{
#if defined(_SPECULARHIGHLIGHTS_OFF)
    return half3(0, 0, 0);
#endif
    half3 specularColor = brightColor * toonSurfaceData.specularColor;
    specularColor *= step(0.2f, toonSurfaceData.specularScale * pow(lightData.NdotH, toonSurfaceData.smoothness));
    return lerp(half3(0, 0, 0), specularColor, diffuseRadiance);
}

half3 ToonDirectLighting(Light light, InputData inputData, ToonLitSurfaceData toonSurfaceData, half isMainLight = 0)
{
    half3 toonDirectLighting = 0;
    
    CustomLightData lightData = CreateCustomLightData(light, inputData);

    half3 brightColor = lightData.lightColor * toonSurfaceData.albedo;
    half3 darkenColor = lightData.lightColor * toonSurfaceData.albedo * toonSurfaceData.shadowColor;

    half diffuseRadiance = ToonLightingDiffuse(lightData, inputData, toonSurfaceData);
    
    toonDirectLighting += lerp(darkenColor, brightColor, diffuseRadiance);
    // toonDirectLighting += ToonLightingSpecular(lightData, toonSurfaceData, brightColor, diffuseRadiance);

    toonDirectLighting = lerp(half3(0, 0, 0), toonDirectLighting, lightData.distanceAttenuation);

    return toonDirectLighting;
}

////////////////////////////////////////////////////////////////////////////////
/// SnowyOwl ToonShading
////////////////////////////////////////////////////////////////////////////////
half4 SnowyOwlFragmentToonLighting(InputData inputData, ToonLitSurfaceData toonSurfaceData)
{
    half4 shadowMask = CalculateShadowMask(inputData);
    AmbientOcclusionFactor aoFactor = (AmbientOcclusionFactor)0;
    uint meshRenderingLayers = GetMeshRenderingLayer();
    Light mainLight = GetMainLight(inputData.shadowCoord);

    LightAccumulator lightAccumulator = CreateLightAccumulator(inputData, toonSurfaceData);
    lightAccumulator.giColor *= toonSurfaceData.albedo;

#if defined(_LIGHT_LAYERS)
    if (IsMatchingLightLayer(mainLight.layerMask, meshRenderingLayers))
#endif
    {
        lightAccumulator.mainLightColor += ToonDirectLighting(mainLight, inputData, toonSurfaceData, 1);
    }

#if defined(_ADDITIONAL_LIGHTS)
    uint pixelLightCount = GetAdditionalLightsCount();

    #if USE_FORWARD_PLUS
        for (uint lightIndex = 0; lightIndex < min(URP_FP_DIRECTIONAL_LIGHTS_COUNT, MAX_VISIBLE_LIGHTS); lightIndex++)
        {
            FORWARD_PLUS_SUBTRACTIVE_LIGHT_CHECK

            Light light = GetAdditionalLight(lightIndex, inputData, shadowMask, aoFactor);

        #if defined(_LIGHT_LAYERS)
            if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
        #endif
            {
                lightAccumulator.additionalLightsColor += ToonDirectLighting(light, inputData, toonSurfaceData, 0);
            }
        }
    #endif

    LIGHT_LOOP_BEGIN(pixelLightCount)
        Light light = GetAdditionalLight(lightIndex, inputData, shadowMask, aoFactor);

    #if defined(_LIGHT_LAYERS)
        if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
    #endif
        {
            lightAccumulator.additionalLightsColor += ToonDirectLighting(light, inputData, toonSurfaceData, 0);
        }
    LIGHT_LOOP_END
#endif

// #if defined(_ADDITIONAL_LIGHTS_VERTEX)
//     lightAccumulator.vertexLightingColor += inputData.vertexLighting * brdfData.diffuse;
// #endif

    return FinalColorOutput(lightAccumulator, toonSurfaceData.alpha);
}

#endif // SNOWYOWL_TOON_LIGHTING_INCLUDE