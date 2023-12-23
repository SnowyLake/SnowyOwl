#ifndef SNOWYOWL_COMMON_LIGHTING_INCLUDED
#define SNOWYOWL_COMMON_LIGHTING_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

#include "CommonLightingData.hlsl"

half3 AccumulateLighting(LightAccumulator lightAccumulator)
{
    half3 lightingAccumulation = 0;
    if (IsOnlyAOLightingFeatureEnabled())
    {
        return lightAccumulator.giColor; // Contains white + AO
    }

    if (IsLightingFeatureEnabled(DEBUGLIGHTINGFEATUREFLAGS_GLOBAL_ILLUMINATION))
    {
        lightingAccumulation += lightAccumulator.giColor;
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

half4 FinalColorOutput(LightAccumulator lightAccumulator, half alpha)
{
    half3 finalColor = AccumulateLighting(lightAccumulator);
    return half4(finalColor, alpha);
}

#endif // SNOWYOWL_COMMON_LIGHTING_INCLUDED