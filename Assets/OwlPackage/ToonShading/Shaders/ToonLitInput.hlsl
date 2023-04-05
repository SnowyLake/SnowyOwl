#ifndef SNOWYOWL_TOONLIT_INPUT_INCLUDED
#define SNOWYOWL_TOONLIT_INPUT_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/CommonMaterial.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/SurfaceInput.hlsl"

#include "Assets/OwlPackage/ToonShading/ShaderLibrary/ShaderVariablesUtils.hlsl"
#include "Assets/OwlPackage/ToonShading/Shaders/ToonData.hlsl"

// NOTE: Do not ifdef the properties here as SRP batcher can not handle different layouts.
CBUFFER_START(UnityPerMaterial)
    float4 _BaseMap_ST;
    half4 _BaseColor;
    half4 _ShadowColor;

    half4 _SmoothnessChannel;
    half4 _SpacularChannel;
    half4 _ShadowThresholdChannel;
    half4 _EmissiveChannel;
    half _SmoothnessScale; 
    half _SpacularScale;
    half _ShadowThresholdScale;
    half _EmissiveScale;

    half _BumpScale;
    half _ShadowTransitionSmoothRange;

    half _GIScale;

    half _Cutoff;
    half _Surface;
CBUFFER_END

TEXTURE2D(_ILMMap);     SAMPLER(sampler_ILMMap);

#if defined(_SSSMAP)
TEXTURE2D(_SSSMap);     SAMPLER(sampler_SSSMap);
    #if defined(_SHADOW_TRANSITION_RAMP)
    EXTURE2D(_ShadowTransitionRampMap);    SAMPLER(sampler_ShadowTransitionRampMap);
    #endif
#else
TEXTURE2D(_RampMap);    SAMPLER(sampler_RampMap);
#endif

inline void InitializeToonLitSurfaceData(float2 uv, out ToonSurfaceData outToonSurfaceData)
{
    half4 albedoAlpha = SampleAlbedoAlpha(uv, TEXTURE2D_ARGS(_BaseMap, sampler_BaseMap));
    outToonSurfaceData.albedo = albedoAlpha.rgb * _BaseColor.rgb;

    outToonSurfaceData.alpha = Alpha(albedoAlpha.a, _BaseColor, _Cutoff);

    half4 ilm = SAMPLE_TEXTURE2D(_ILMMap, sampler_ILMMap, uv);
    outToonSurfaceData.smoothness = GetValueByTexChannel(ilm, _SmoothnessChannel) * _SmoothnessScale;
    outToonSurfaceData.specularScale = GetValueByTexChannel(ilm, _SpacularChannel) * _SpacularScale;
    outToonSurfaceData.shadowThreshold = GetValueByTexChannel(ilm, _ShadowThresholdChannel) * _ShadowThresholdScale + 0.0001;

#if defined(_EMISSION) && !defined(_INNER_OUTLINE_ON)
    outToonSurfaceData.emission = GetValueByTexChannel(ilm, _EmissiveChannel) * _EmissiveScale * outToonSurfaceData.albedo;
#elif !defined(_EMISSION) && defined(_INNER_OUTLINE_ON) && defined(_OUTLINE_ON)
    outToonSurfaceData.albedo *= half3(ilm.a, ilm.a, ilm.a);
    outToonSurfaceData.emission = half3(0, 0, 0);
#else
    outToonSurfaceData.emission = half3(0, 0, 0);
#endif

#if defined(_SSSMAP)
    outToonSurfaceData.shadowColor = SAMPLE_TEXTURE2D(_SSSMap, sampler_SSSMap, uv).rgb * _ShadowColor;
#else
    outToonSurfaceData.shadowColor = half3(1, 1, 1); // TODO: Shadow RampMap Sample
#endif

    outToonSurfaceData.normalTS = SampleNormal(uv, TEXTURE2D_ARGS(_BumpMap, sampler_BumpMap), _BumpScale);
}

#endif // SNOWYOWL_TOONLIT_INPUT_INCLUDE