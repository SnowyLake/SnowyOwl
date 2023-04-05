#ifndef SNOWYOWL_TOON_LIGHTING_INCLUDED
#define SNOWYOWL_TOON_LIGHTING_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Assets/OwlPackage/ToonShading/Shaders/ToonLitInput.hlsl"

struct ToonLightingData
{
    half3 giColor;
    half3 mainLightColor;
    half3 additionalLightsColor;
    half3 vertexLightingColor;
    half3 emissionColor;
};

ToonLightingData CreateToonLightingData(InputData inputData, ToonSurfaceData toonSurfaceData)
{
    ToonLightingData toonLightingData;

    toonLightingData.giColor = inputData.bakedGI;
    toonLightingData.emissionColor = toonSurfaceData.emission;
    toonLightingData.vertexLightingColor = 0;
    toonLightingData.mainLightColor = 0;
    toonLightingData.additionalLightsColor = 0;

    return toonLightingData;
}

half4 ToonLighting(InputData inputData, ToonSurfaceData toonSurfaceData)
{
    #if defined(_SPECULARHIGHLIGHTS_OFF)
    bool specularHighlightsOff = true;
    #else
    bool specularHighlightsOff = false;
    #endif
    
    uint meshRenderingLayers = GetMeshRenderingLightLayer();
    Light mainLight = GetMainLight();

    ToonLightingData toonLightingData = CreateToonLightingData(inputData, toonSurfaceData);

    if (IsMatchingLightLayer(mainLight.layerMask, meshRenderingLayers))
    {
        
    }

    //return CalculateFinalColor(lightingData, surfaceData.alpha);
    return half4(toonSurfaceData.albedo, toonSurfaceData.alpha);
}

#endif // SNOWYOWL_TOON_LIGHTING_INCLUDE