#ifndef SNOWYOWL_TOON_DATA_INCLUDED
#define SNOWYOWL_TOON_DATA_INCLUDED

struct ToonSurfaceData
{
    half3 albedo;
    half  alpha;

    half smoothness;
    half specularScale;
    half3 specularColor;

    half giScale;
    half3 emissiveColor;

    half shadowThreshold;
    half3 shadowColor;
    
    half3 normalTS;
};

#endif // SNOWYOWL_TOON_DATA_INCLUDE