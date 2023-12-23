#ifndef SNOWYOWL_TOON_LIGHTING_DATA_INCLUDED
#define SNOWYOWL_TOON_LIGHTING_DATA_INCLUDED

struct ToonLitSurfaceData
{
    half3 albedo;
    half  alpha;

    half diffuseStepSmoothness;
    half diffuseStepSmoothnessOffset;
    
    half smoothness;
    half specularScale;
    half3 specularColor;
    
    half shadowScale;
    half3 shadowColor;
    half shadowThreshold;
    
    half3 normalTS;

    half giScale;
    half3 emissionColor;
};


#endif // SNOWYOWL_TOON_LIGHTING_DATA_INCLUDED