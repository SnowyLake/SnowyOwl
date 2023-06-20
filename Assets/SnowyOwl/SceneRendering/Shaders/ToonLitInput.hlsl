#ifndef SNOWYOWL_TOONLIT_INPUT_INCLUDED
#define SNOWYOWL_TOONLIT_INPUT_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/CommonMaterial.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/SurfaceInput.hlsl"

#include "Assets/SnowyOwl/SceneRendering/ShaderLibrary/ShaderVariablesUtils.hlsl"
#include "Assets/SnowyOwl/SceneRendering/Shaders/ToonData.hlsl"

// NOTE: Do not ifdef the properties here as SRP batcher can not handle different layouts.
CBUFFER_START(UnityPerMaterial)
    float4 _BaseMap_ST;

    half4 _BaseColor;
    half4 _CustomSpecularColor;
    half4 _ShadowColor;
    half4 _EmissiveColor;
    
    half4 _OutlineColor;

    half _Smoothness; 
    half _SpacularScale;
    half _CustomSpecularColorWeight;
    half _ShadowThreshold;
    half _ShadowTransitionSmoothRange;
    half _EmissiveScale;
    half _GIScale;
    half _BumpScale;

    half _OutlineWidth;
    
    half _Cutoff;
    half _Surface;
CBUFFER_END

TEXTURE2D(_ILMMap);     SAMPLER(sampler_ILMMap);

#if defined(_SHADOWMAP_SSS)
TEXTURE2D(_SSSMap);     SAMPLER(sampler_SSSMap);
    #if defined(_SHADOWTRANSITION_RAMP)
    EXTURE2D(_ShadowTransitionRampMap);    SAMPLER(sampler_ShadowTransitionRampMap);
    #endif
#elif defined(_SHADOWMAP_RAMP)
TEXTURE2D(_RampMap);    SAMPLER(sampler_RampMap);
#endif

inline void InitializeToonLitSurfaceData(float2 uv, out ToonSurfaceData outToonSurfaceData)
{
    half4 albedoAlpha = SampleAlbedoAlpha(uv, TEXTURE2D_ARGS(_BaseMap, sampler_BaseMap));
    outToonSurfaceData.albedo = albedoAlpha.rgb * _BaseColor.rgb;
    outToonSurfaceData.alpha = Alpha(albedoAlpha.a, _BaseColor, _Cutoff);

    half4 ilm = SAMPLE_TEXTURE2D(_ILMMap, sampler_ILMMap, uv);
    
    outToonSurfaceData.smoothness = GetValueByTexChannel(ilm, _SmoothnessChannel) * _Smoothness;
    outToonSurfaceData.specularScale = GetValueByTexChannel(ilm, _SpacularChannel) * _SpacularScale;
    outToonSurfaceData.customSpecularColor = _CustomSpecularColor.rgb;
    outToonSurfaceData.customSpecularColorWeight = _CustomSpecularColorWeight;

    outToonSurfaceData.giScale = _GIScale;
#if defined(_EMISSION)
    half emissive = GetValueByTexChannel(ilm, _EmissiveChannel) * _EmissiveScale;
    outToonSurfaceData.emissiveColor = emissive * _EmissiveColor.rgb;
#elif !defined(_EMISSION) && defined(_INNER_OUTLINE_ON) && defined(_OUTLINE_ON)
    outToonSurfaceData.albedo *= half3(ilm.a, ilm.a, ilm.a);
    outToonSurfaceData.emissiveColor = half3(0, 0, 0);
#else
    outToonSurfaceData.emissiveColor = half3(0, 0, 0);
#endif

    outToonSurfaceData.shadowThreshold = GetValueByTexChannel(ilm, _ShadowThresholdChannel) * (_ShadowThreshold + 0.0001);
#if defined(_SHADOWMAP_SSS)
    outToonSurfaceData.shadowColor = SAMPLE_TEXTURE2D(_SSSMap, sampler_SSSMap, uv).rgb * _ShadowColor;
#elif defined(_SHADOWMAP_RAMP)
    outToonSurfaceData.shadowColor = half3(1, 1, 1); // TODO: Shadow RampMap Sample
#else
    outToonSurfaceData.shadowColor = _ShadowColor;
#endif

    outToonSurfaceData.normalTS = SampleNormal(uv, TEXTURE2D_ARGS(_BumpMap, sampler_BumpMap), _BumpScale);
}

#endif // SNOWYOWL_TOONLIT_INPUT_INCLUDE