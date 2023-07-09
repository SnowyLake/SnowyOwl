#ifndef SNOWYOWL_TOONLIT_INPUT_INCLUDED
#define SNOWYOWL_TOONLIT_INPUT_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/CommonMaterial.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/SurfaceInput.hlsl"

#include "Assets/SnowyOwl/ShaderLibrary/TextureChannelUtils.hlsl"
#include "Assets/SnowyOwl/Shaders/ToonShading/ToonData.hlsl"

// NOTE: Do not ifdef the properties here as SRP batcher can not handle different layouts.
CBUFFER_START(UnityPerMaterial)
    float4 _BaseMap_ST;

    half4 _BaseColor;
    half4 _CustomSpecularColor;
    half4 _ShadowColor;
    half4 _EmissionColor;
    
    half4 _OutlineColor;

    half _Smoothness; 
    half _SpacularScale;
    half _CustomSpecularColorWeight;
    half _ShadowThreshold;
    half _ShadowSSSRampScale;
    half _EmissionScale;
    half _GIScale;
    half _BumpScale;

    half _OutlineWidth;
    
    half _Cutoff;
    half _Surface;
CBUFFER_END

TEXTURE2D(_ILMMap);         SAMPLER(sampler_ILMMap);

#if defined(_SHADOWMAP_SSS) || defined(_SHADOWMAP_SSS_RAMP)
    TEXTURE2D(_ShadowSSSMap);         SAMPLER(sampler_ShadowSSSMap);
    #if defined(_SHADOWMAP_SSS_RAMP)
        TEXTURE2D(_ShadowSSSRampMap);     SAMPLER(sampler_ShadowSSSRampMap);
    #endif
#elif defined(_SHADOWMAP_MULTICOLOR_RAMP)
    TEXTURE2D(_ShadowRampMap);    SAMPLER(sampler_ShadowRampMap);
#endif

inline void InitializeToonLitSurfaceData(float2 uv, out ToonSurfaceData outToonSurfaceData)
{
    half4 albedoAlpha = SampleAlbedoAlpha(uv, TEXTURE2D_ARGS(_BaseMap, sampler_BaseMap));
    outToonSurfaceData.albedo = albedoAlpha.rgb * _BaseColor.rgb;
    outToonSurfaceData.alpha = Alpha(albedoAlpha.a, _BaseColor, _Cutoff);

    half4 ilm = SAMPLE_TEXTURE2D(_ILMMap, sampler_ILMMap, uv);
    
    outToonSurfaceData.smoothness = GetILMSmoothness(ilm, CHANNEL_R) * _Smoothness;
    outToonSurfaceData.specularScale = GetILMSpecularScale(ilm, CHANNEL_B) * _SpacularScale;
    outToonSurfaceData.customSpecularColor = _CustomSpecularColor.rgb;
    outToonSurfaceData.customSpecularColorWeight = _CustomSpecularColorWeight;

    outToonSurfaceData.giScale = _GIScale;
#if defined(_EMISSION) && !defined(_OUTLINE_INNER_ON)
    half emission = GetILMEmission(ilm, CHANNEL_A) * _EmissionColor;
    outToonSurfaceData.emissionColor = emission * _EmissionColor.rgb;
#elif defined(_OUTLINE_ON) && defined(_OUTLINE_INNER_ON)
    outToonSurfaceData.albedo *= half3(ilm.a, ilm.a, ilm.a);
    outToonSurfaceData.emissionColor = half3(0, 0, 0);
#else
    outToonSurfaceData.emissionColor = half3(0, 0, 0);
#endif

    outToonSurfaceData.shadowThreshold = saturate(GetILMShadowThreshold(ilm, CHANNEL_G) * (_ShadowThreshold + 0.0001));
#if defined(_SHADOWMAP_SSS) || defined(_SHADOWMAP_SSS_RAMP)
    outToonSurfaceData.shadowColor = SAMPLE_TEXTURE2D(_ShadowSSSMap, sampler_ShadowSSSMap, uv).rgb * _ShadowColor;
#elif defined(_SHADOWMAP_MULTICOLOR_RAMP)
    outToonSurfaceData.shadowColor = half3(1, 1, 1); // TODO: Shadow RampMap Sample
#else
    outToonSurfaceData.shadowColor = _ShadowColor;
#endif

    outToonSurfaceData.normalTS = SampleNormal(uv, TEXTURE2D_ARGS(_BumpMap, sampler_BumpMap), _BumpScale);
}

#endif // SNOWYOWL_TOONLIT_INPUT_INCLUDE