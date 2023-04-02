#ifndef SNOWYOWL_TOON_DATA_INCLUDED
#define SNOWYOWL_TOON_DATA_INCLUDED

struct ToonSurfaceData
{
    half3 albedo;
    half  alpha;
    
    half smoothness;
    half specularScale;
    half shadowThreshold;
    half3 shadowColor;
    
    half3 emission;
    half3 normalTS;
};


#endif // SNOWYOWL_TOON_DATA_INCLUDE