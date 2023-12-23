#ifndef SNOWYOWL_TOONLIT_PASS_INCLUDED
#define SNOWYOWL_TOONLIT_PASS_INCLUDED

#include "ToonLitInput.hlsl"

// ==================================================================================================
// Forward Pass
// ==================================================================================================
ForwardVaryings ToonLitForwardVertex(ForwardAttributes input)
{
    ForwardVaryings output = (ForwardVaryings)0;

    VertexPositionInputs vertexInput = GetVertexPositionInputs(input.positionOS.xyz);
    VertexNormalInputs normalInput = GetVertexNormalInputs(input.normalOS, input.tangentOS);

    output.positionCS = vertexInput.positionCS;
    output.positionOS = input.positionOS;
    output.uv.xy = TRANSFORM_TEX(input.texcoord, _BaseMap);
    output.uv.zw = 0; // TODO: MatcapUV

    output.positionWS = vertexInput.positionWS;
    output.normalWS = normalInput.normalWS;
#if defined(_NORMALMAP)
    output.tangentWS = float3(normalInput.tangentWS);
    output.bitangentWS = float3(normalInput.bitangentWS);
#endif

    output.color = input.color;
    
    half fogFactor = 0;
#if !defined(_FOG_FRAGMENT)
    fogFactor = ComputeFogFactor(vertexInput.positionCS.z);
#endif
    half3 vertexLight = VertexLighting(vertexInput.positionWS, normalInput.normalWS);
    output.fogFactorAndVertexLight = half4(fogFactor, vertexLight);
    
    output.vertexSH = SampleSHVertex(output.normalWS.xyz);
    
    return output;
}

// Used in Toon Standard shader
half4 ToonLitForwardFragment(ForwardVaryings input) : SV_Target
{
    ToonLitSurfaceData surfaceData;
    InitializeToonLitSurfaceData(input.uv.xy, surfaceData);
    
    InputData inputData;
    InitializeInputData(input, surfaceData.normalTS, inputData);
    SETUP_DEBUG_TEXTURE_DATA(inputData, input.uv, _BaseMap);

    half4 color = SnowyOwlFragmentToonLighting(inputData, surfaceData);

    color.rgb = MixFog(color.rgb, inputData.fogCoord);
    color.a = OutputAlpha(color.a, _Surface);

    return color;
}


// ==================================================================================================
// Outline Pass
// ==================================================================================================
OutlineVaryings OutlinePassVertex(OutlineAttributes input)
{
    OutlineVaryings output = (OutlineVaryings)0;

#if defined(_OUTLINE_SMOOTHEDNORMAL)
    float3 vertNormal = input.color.rgb * 2 - 1;

    input.normalOS.xyz = normalize(input.normalOS.xyz);
    input.tangentOS.xyz = normalize(input.tangentOS.xyz);

    float3 bitangentOS = cross(input.normalOS.xyz, input.tangentOS.xyz) * input.tangentOS.w * unity_WorldTransformParams.w;

    float3x3 tangentToObject = float3x3(input.tangentOS.x, bitangentOS.x, input.normalOS.x,
                                        input.tangentOS.y, bitangentOS.y, input.normalOS.y,
                                        input.tangentOS.z, bitangentOS.z, input.normalOS.z);

    vertNormal = mul(tangentToObject, vertNormal); 
    input.normalOS = vertNormal;
#endif 

    float4 positionVS = mul(UNITY_MATRIX_MV, input.positionOS);
    float4 position = positionVS / positionVS.w;

    float s = -(positionVS.z / unity_CameraProjection[1].y);
    float power = pow(max(s, 0), 0.7);
    float3 normalVS = TransformWorldToViewDir(TransformObjectToWorldNormal(input.normalOS, true), true);
    normalVS.z = 0.01;
    float width = power * _OutlineWidth * input.color.a;
    position.xy += normalVS.xy * width * pow(1, 0.3);
    output.positionCS = TransformWViewToHClip(position.xyz);
    output.positionWS = mul(UNITY_MATRIX_I_V, position).xyz;

    float4 originPositionCS = TransformObjectToHClip(input.positionOS.xyz);
#if !defined(_OUTLINEHIDE_OFF)
    float dist = distance(UNITY_MATRIX_M._m03_m13_m23, GetCameraPositionWS());
    half _OutlineHideDistance = 10; //TempDef
    output.positionCS = lerp(output.positionCS, originPositionCS, step(_OutlineHideDistance, dist));
#endif
    
    output.uv.xy = input.texcoord0;
    output.uv.zw = input.texcoord1;
    output.color = input.color;
    output.positionOSAndFogFactor.xyz = input.positionOS.xyz;
    output.screenPos = ComputeScreenPos(output.positionCS);
    float fogFactor = 0;//UnityComputeFogFactor(output.positionCS.z);
    output.positionOSAndFogFactor.w = fogFactor;
    
    return output;
}

half4 OutlinePassFragment(OutlineVaryings input) : SV_TARGET
{
    half4 finalColor = half4(0, 0, 0, 0);

    // 透明物体，顶点色alpha为0直接剔除
    clip(input.color.a - 0.01);
    
    half4 baseColor = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, input.uv.xy);
    finalColor.rgb = lerp(_OutlineColor.rgb, _OutlineColor.rgb * baseColor.rgb, _OutlineColor.a);
    finalColor.a = 1;
    
    return finalColor;
}
#endif // SNOWYOWL_TOONLIT_PASS_INCLUDED