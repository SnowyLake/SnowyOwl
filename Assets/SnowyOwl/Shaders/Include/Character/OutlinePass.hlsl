#ifndef SNOWYOWL_OUTLINE_PASS_INCLUDED
#define SNOWYOWL_OUTLINE_PASS_INCLUDED

#include "ToonLitInput.hlsl"

// TODO: control outline width by vertex color
struct Attributes
{
    float4 positionOS   : POSITION;
    float4 normalOS     : NORMAL;
    float4 tangent      : TANGENT;
    float4 texcoord     : TEXCOORD0;
    UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct Varyings
{
    float2 uv         : TEXCOORD0;
    float3 positionWS : TEXCOORD1;
    half   fogFactor  : TEXCOORD2;
    float4 positionCS : SV_POSITION;
    UNITY_VERTEX_INPUT_INSTANCE_ID
};

Varyings OutlinePassVertex(Attributes input)
{
    Varyings output = (Varyings)0;
#if !defined(_OUTLINE_ON)
    return output;
#endif

    UNITY_SETUP_INSTANCE_ID(input);

    output.uv = TRANSFORM_TEX(input.texcoord, _BaseMap);
    
    VertexPositionInputs vertexInput = GetVertexPositionInputs(input.positionOS.xyz);
    VertexNormalInputs normalInput = GetVertexNormalInputs(input.normalOS);

    float3 normalCS = TransformWorldToHClipDir(normalInput.normalWS);
    float2 normalExt = normalize(normalCS.xy) * _OutlineWidth * 0.05;
    float4 scaledScreenParams = GetScaledScreenParams();
    normalExt.x *= abs(scaledScreenParams.y / scaledScreenParams.x);
    output.positionCS = vertexInput.positionCS;
    output.positionCS.xy += normalExt * output.positionCS.w * clamp(1 / output.positionCS.w, 0, 1);
    
    output.positionWS = vertexInput.positionWS;

    half fogFactor = 0;
    #if !defined(_FOG_FRAGMENT)
        output.fogFactor = ComputeFogFactor(vertexInput.positionCS.z);
    #endif

    return output;
}

half4 OutlinePassFragment(Varyings input) : SV_TARGET
{
#if !defined(_OUTLINE_ON)
    return 0;
#endif
    half4 color;
    half4 albedoAlpha = SampleAlbedoAlpha(input.uv, TEXTURE2D_ARGS(_BaseMap, sampler_BaseMap));
    color.rgb = albedoAlpha.rgb * _OutlineColor.rgb;
    color.a = Alpha(albedoAlpha.a, _BaseColor, _Cutoff);

    half fogCoord = InitializeInputDataFog(float4(input.positionWS, 1.0), input.fogFactor);
    color.rgb = MixFog(color.rgb, fogCoord);
    color.a = OutputAlpha(color.a, _Surface);
    return color;
}

#endif // SNOWYOWL_OUTLINE_PASS_INCLUDE