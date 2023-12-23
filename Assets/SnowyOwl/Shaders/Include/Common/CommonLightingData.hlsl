#ifndef SNOWYOWL_COMMON_LIGHTING_DATA_INCLUDED
#define SNOWYOWL_COMMON_LIGHTING_DATA_INCLUDED

struct LightAccumulator
{
    half3 mainLightColor;
    half3 additionalLightsColor;
    half3 vertexLightingColor;
    half3 giColor;
    half3 emissionColor;
};

struct CustomLightData
{
    half3 lightColor;
    half3 lightDir;
    float distanceAttenuation;
    half shadowAttenuation;
    half NdotL;
    half NdotV;
    half NdotH;
    half LdotH;
};

#endif // SNOWYOWL_COMMON_LIGHTING_DATA_INCLUDED