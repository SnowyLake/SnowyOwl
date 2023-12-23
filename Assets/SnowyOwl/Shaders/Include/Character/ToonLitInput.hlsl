#ifndef SNOWYOWL_TOONLIT_INPUT_INCLUDED
#define SNOWYOWL_TOONLIT_INPUT_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/CommonMaterial.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/SurfaceInput.hlsl"

#include "../Common/ToonLighting.hlsl"

CBUFFER_START(UnityPerMaterial)
    float4 _BaseMap_ST;
    half4 _BaseColor;
    half4 _SpecularColor;
    half4 _ShadowColor;
    half4 _EmissionColor;
    half4 _OutlineColor;
    half _DiffuseStepSmoothness;
    half _DiffuseStepSmoothnessOffset;
    half _SpacularScale;
    half _Smoothness; 
    half _EmissionScale;
    half _ShadowScale;
    half _BumpScale;
    half _GIScale;

    half _OutlineWidth;
    
    half _Cutoff;
    half _Surface;
CBUFFER_END

TEXTURE2D(_ILMMap);         SAMPLER(sampler_ILMMap);

#if defined(_SHADOWMAP_SSS) || defined(_SHADOWMAP_SSS_RAMP)
    TEXTURE2D(_ShadowSSSMap);     SAMPLER(sampler_ShadowSSSMap);
#endif

#if defined(_SHADOWMAP_SSS_RAMP) || defined(_SHADOWMAP_MULTICOLOR_RAMP)
    TEXTURE2D(_ShadowRampMap);    SAMPLER(sampler_ShadowRampMap);
#endif

// ===================================================================
// Forward Pass
// ===================================================================
struct ForwardAttributes
{
    float4 positionOS   : POSITION;
    float4 tangentOS    : TANGENT;
    float3 normalOS     : NORMAL;
    float2 texcoord     : TEXCOORD0;
    half4 color         : COLOR;
};

struct ForwardVaryings
{
    float4 positionCS               : SV_POSITION;
    float4 positionOS               : TEXCOORD0;
    float4 uv                       : TEXCOORD1;    // zw：MatCapUV
    
    float3 positionWS               : TEXCOORD2;
    float3 normalWS                 : TEXCOORD3;
#if defined(_NORMALMAP)
    float3 tangentWS                : TEXCOORD4;
    float3 bitangentWS              : TEXCOORD5;
#endif

    half4 color                     : TEXCOORD6;
    half4 fogFactorAndVertexLight   : TEXCOORD7;
    half3 vertexSH                  : TEXCOORD8;
};

// ===================================================================
// Outline Pass
// ===================================================================
struct OutlineAttributes
{
    float4 positionOS   : POSITION;
    float4 tangentOS    : TANGENT;
    float3 normalOS     : NORMAL;
    float2 texcoord0    : TEXCOORD0;
    float2 texcoord1    : TEXCOORD1;
    half4 color         : COLOR;
};

struct OutlineVaryings
{
    float4 positionCS                   : SV_POSITION;
    float4 uv                           : TEXCOORD0;
    float3 positionWS                   : TEXCOORD1;
    float4 positionOSAndFogFactor       : TEXCOORD2;
    float4 screenPos                    : TEXCOORD3;
    half4 color                         : TEXCOORD4;
};


// ==================================================================================================
// Initialize Data Functions
// ==================================================================================================
void InitializeToonLitSurfaceData(float2 uv, out ToonLitSurfaceData outSurfaceData)
{
    half4 albedoAlpha = SampleAlbedoAlpha(uv, TEXTURE2D_ARGS(_BaseMap, sampler_BaseMap));
    half4 ilm = SAMPLE_TEXTURE2D(_ILMMap, sampler_ILMMap, uv);
    
    outSurfaceData.albedo = albedoAlpha.rgb * _BaseColor.rgb;
#if defined(_OUTLINE_INNER_ON)
    outSurfaceData.albedo *= half3(ilm.a, ilm.a, ilm.a);
#endif
    
    outSurfaceData.alpha = Alpha(albedoAlpha.a, _BaseColor, _Cutoff);

    outSurfaceData.diffuseStepSmoothness = _DiffuseStepSmoothness;
    outSurfaceData.diffuseStepSmoothnessOffset = _DiffuseStepSmoothnessOffset;
    
    outSurfaceData.smoothness = ilm.r * _Smoothness;
    outSurfaceData.specularScale = ilm.b * _SpacularScale;
    outSurfaceData.specularColor = _SpecularColor.rgb;

    outSurfaceData.giScale = _GIScale;
#if !defined(_OUTLINE_INNER_ON)
    outSurfaceData.emissionColor = ilm.a * _EmissionScale * _EmissionColor.rgb;
#else
    outSurfaceData.emissionColor = half3(0, 0, 0);
#endif

    outSurfaceData.shadowThreshold = ilm.g;
    outSurfaceData.shadowScale = _ShadowScale;
#if defined(_SHADOWMAP_SSS) || defined(_SHADOWMAP_SSS_RAMP)
    outSurfaceData.shadowColor = SAMPLE_TEXTURE2D(_ShadowSSSMap, sampler_ShadowSSSMap, uv).rgb * _ShadowColor;
#elif defined(_SHADOWMAP_MULTICOLOR_RAMP)
    outSurfaceData.shadowColor = half3(1, 1, 1); // TODO: Shadow RampMap Sample
#else
    outSurfaceData.shadowColor = _ShadowColor;
#endif

    outSurfaceData.normalTS = SampleNormal(uv, TEXTURE2D_ARGS(_BumpMap, sampler_BumpMap), _BumpScale);
}

void InitializeInputData(ForwardVaryings input, half3 normalTS, out InputData outInputData)
{
    outInputData = (InputData)0;
    
    outInputData.positionWS = input.positionWS;
    outInputData.positionCS = input.positionCS;
    
#if defined(_NORMALMAP)
    outInputData.tangentToWorld = half3x3(input.tangentWS, input.bitangentWS, input.normalWS);
    outInputData.normalWS = TransformTangentToWorld(normalTS, outInputData.tangentToWorld);
#else
    outInputData.normalWS = input.normalWS;
#endif
    outInputData.normalWS = NormalizeNormalPerPixel(outInputData.normalWS);

    half3 viewDirWS = GetWorldSpaceNormalizeViewDir(input.positionWS);
    outInputData.viewDirectionWS = viewDirWS;

#if defined(MAIN_LIGHT_CALCULATE_SHADOWS)
    outInputData.shadowCoord = TransformWorldToShadowCoord(outInputData.positionWS);
#else
    outInputData.shadowCoord = float4(0, 0, 0, 0);
#endif

    outInputData.fogCoord = InitializeInputDataFog(float4(input.positionWS, 1.0), input.fogFactorAndVertexLight.x);
    outInputData.vertexLighting = input.fogFactorAndVertexLight.yzw;

    outInputData.bakedGI = SampleSHPixel(input.vertexSH, outInputData.normalWS);
    outInputData.normalizedScreenSpaceUV = GetNormalizedScreenSpaceUV(input.positionCS);
    outInputData.shadowMask = SAMPLE_SHADOWMASK(input.staticLightmapUV);

    
#if defined(DEBUG_DISPLAY)
    #if defined(DYNAMICLIGHTMAP_ON)
        outInputData.dynamicLightmapUV = input.dynamicLightmapUV;
    #endif
    #if defined(LIGHTMAP_ON)
        outInputData.staticLightmapUV = input.staticLightmapUV;
    #else
        outInputData.vertexSH = input.vertexSH;
    #endif
#endif
}
#endif // SNOWYOWL_TOONLIT_INPUT_INCLUDE