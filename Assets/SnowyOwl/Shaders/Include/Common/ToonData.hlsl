#ifndef SNOWYOWL_TOON_DATA_INCLUDED
#define SNOWYOWL_TOON_DATA_INCLUDED

struct ToonSurfaceData
{
    half3 albedo;
    half  alpha;

    half specularScale;
    half smoothness;
    half3 customSpecularColor;
    half customSpecularColorWeight;

    half giScale;
    half3 emissionColor;

    half shadowThreshold;
    half3 shadowColor;
    
    half3 normalTS;
};

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


#endif // SNOWYOWL_TOON_DATA_INCLUDE