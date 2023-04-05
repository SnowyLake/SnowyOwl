#ifndef SNOWYOWL_TOON_LIGHTING_INCLUDED
#define SNOWYOWL_TOON_LIGHTING_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Assets/OwlPackage/ToonShading/Shaders/ToonLitInput.hlsl"

///////////////////////////////////////////////////////////////////////////////
//                      Lighting Functions                                   //
///////////////////////////////////////////////////////////////////////////////
half3 ToonLightingDiffuse(half3 brightColor, half3 shadowColor, half isShadow)
{
    return lerp(brightColor, shadowColor, isShadow);
}

half3 ToonLightingSpecular(half3 brightColor, half3 lightDir, half3 normal, half3 viewDir, half smoothness, half specularScale, half isShadow)
{

    float3 halfVec = SafeNormalize(float3(lightDir) + float3(viewDir));
    half NdotH = half(saturate(dot(normal, halfVec)));
    half modifier = pow(NdotH, smoothness);
    half3 specularColor = brightColor * step(0.2f, specularScale * modifier);
    return lerp(specularColor, half3(0, 0, 0), isShadow);
}

half3 ToonDirectLighting(Light light, InputData inputData, ToonSurfaceData toonSurfaceData, half isMainLight = 0)
{
    half3 brightColor = toonSurfaceData.albedo;
	half3 shadowColor = toonSurfaceData.albedo * toonSurfaceData.shadowColor;

    half NdotL = saturate(dot(inputData.normalWS, light.direction));
    

    half isShadow = step(NdotL * light.shadowAttenuation, toonSurfaceData.shadowThreshold);

    half3 toonDirectLighting = 0;
    toonDirectLighting += ToonLightingDiffuse(brightColor, shadowColor, isShadow);
    toonDirectLighting += ToonLightingSpecular(brightColor, light.direction, inputData.normalWS, inputData.viewDirectionWS, toonSurfaceData.smoothness, toonSurfaceData.specularScale, isShadow);
    toonDirectLighting = lerp(half3(0, 0, 0), toonDirectLighting, light.distanceAttenuation);
    return light.color * toonDirectLighting;

    //return ToonLightingDiffuse(light.color, light.direction, inputData.normalWS);
}

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

    toonLightingData.giColor = inputData.bakedGI * _GIScale * toonSurfaceData.albedo;
    toonLightingData.emissionColor = toonSurfaceData.emission;
    toonLightingData.vertexLightingColor = 0;
    toonLightingData.mainLightColor = 0;
    toonLightingData.additionalLightsColor = 0;

    return toonLightingData;
}

half3 CalculateToonLightingColor(ToonLightingData toonLightingData, half3 albedo)
{
    half3 lightingColor = 0;
    if (IsOnlyAOLightingFeatureEnabled())
    {
        return toonLightingData.giColor; // Contains white + AO
    }

    if (IsLightingFeatureEnabled(DEBUGLIGHTINGFEATUREFLAGS_GLOBAL_ILLUMINATION))
    {
        lightingColor += toonLightingData.giColor;
    }

    if (IsLightingFeatureEnabled(DEBUGLIGHTINGFEATUREFLAGS_MAIN_LIGHT))
    {
        lightingColor += toonLightingData.mainLightColor;
    }

    if (IsLightingFeatureEnabled(DEBUGLIGHTINGFEATUREFLAGS_ADDITIONAL_LIGHTS))
    {
        lightingColor += toonLightingData.additionalLightsColor;
    }

    if (IsLightingFeatureEnabled(DEBUGLIGHTINGFEATUREFLAGS_VERTEX_LIGHTING))
    {
        lightingColor += toonLightingData.vertexLightingColor;
    }

    lightingColor *= albedo;

    if (IsLightingFeatureEnabled(DEBUGLIGHTINGFEATUREFLAGS_EMISSION))
    {
        lightingColor += toonLightingData.emissionColor;
    }

    return lightingColor;
}

half4 CalculateToonFinalColor(ToonLightingData toonLightingData, half alpha)
{
    half3 finalColor = CalculateToonLightingColor(toonLightingData, 1);

    return half4(finalColor, alpha);
}

////////////////////////////////////////////////////////////////////////////////
/// Owl ToonShading
////////////////////////////////////////////////////////////////////////////////
half4 OwlToonShadingFragment(InputData inputData, ToonSurfaceData toonSurfaceData)
{
#if defined(_SPECULARHIGHLIGHTS_OFF)
    bool specularHighlightsOff = true;
#else
    bool specularHighlightsOff = false;
#endif
    
    uint meshRenderingLayers = GetMeshRenderingLightLayer();
    //half4 shadowMask = CalculateShadowMask(inputData);
    Light mainLight = GetMainLight(inputData.shadowCoord);

    ToonLightingData toonLightingData = CreateToonLightingData(inputData, toonSurfaceData);

    if (IsMatchingLightLayer(mainLight.layerMask, meshRenderingLayers))
    {
        toonLightingData.mainLightColor += ToonDirectLighting(mainLight, inputData, toonSurfaceData, 1);
    }
    //return half4(toonLightingData.mainLightColor,1);
    #if defined(_ADDITIONAL_LIGHTS)
    uint pixelLightCount = GetAdditionalLightsCount();

    #if USE_CLUSTERED_LIGHTING
    for (uint lightIndex = 0; lightIndex < min(_AdditionalLightsDirectionalCount, MAX_VISIBLE_LIGHTS); lightIndex++)
    {
        Light light = GetAdditionalLight(lightIndex, inputData.positionWS);

        if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
        {
            toonLightingData.additionalLightsColor += ToonDirectLighting(light, inputData, toonSurfaceData, 0);
        }
    }
    #endif

    LIGHT_LOOP_BEGIN(pixelLightCount)
        Light light = GetAdditionalLight(lightIndex, inputData.positionWS);
        if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
        {
            toonLightingData.additionalLightsColor += ToonDirectLighting(light, inputData, toonSurfaceData, 0);
        }
    LIGHT_LOOP_END
    #endif

    return CalculateToonFinalColor(toonLightingData, toonSurfaceData.alpha);
}

#endif // SNOWYOWL_TOON_LIGHTING_INCLUDE