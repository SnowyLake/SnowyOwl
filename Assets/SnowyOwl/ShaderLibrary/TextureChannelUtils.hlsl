#ifndef SNOWYOWL_TEXTURE_CHANNEL_UTILS_INCLUDED
#define SNOWYOWL_TEXTURE_CHANNEL_UTILS_INCLUDED

#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Macros.hlsl"

#define CHANNEL_R half4(1, 0, 0, 0)
#define CHANNEL_G half4(0, 1, 0, 0)
#define CHANNEL_B half4(0, 0, 1, 0)
#define CHANNEL_A half4(0, 0, 0, 1)

half GetTexChannelValue(half4 tex, half4 channel)
{
    return dot(tex, channel);
}
// ----------------------------------------------------------------
// ILM Channel Getter
// ----------------------------------------------------------------
half GetILMSmoothness(half4 tex, half4 defaultChannel)
{
#if defined(_ENABLE_CUSTOM_TEX_CHANNEL)
    #if   defined(MERGE_NAME(_ILM_SMOOTHNESS, _CHANNEL_R)) 
        return GetTexChannelValue(tex, CHANNEL_R);
    #elif defined(MERGE_NAME(_ILM_SMOOTHNESS, _CHANNEL_G)) 
        return GetTexChannelValue(tex, CHANNEL_G);
    #elif defined(MERGE_NAME(_ILM_SMOOTHNESS, _CHANNEL_B)) 
        return GetTexChannelValue(tex, CHANNEL_B);
    #elif defined(MERGE_NAME(_ILM_SMOOTHNESS, _CHANNEL_A)) 
        return GetTexChannelValue(tex, CHANNEL_A);
    #endif
#else
    return GetTexChannelValue(tex, defaultChannel);
#endif
}
half GetILMSpecularScale(half4 tex, half4 defaultChannel)
{
#if defined(_ENABLE_CUSTOM_TEX_CHANNEL)
    #if   defined(MERGE_NAME(_ILM_SPECULARSCALE, _CHANNEL_R))
        return GetTexChannelValue(tex, CHANNEL_R);
    #elif defined(MERGE_NAME(_ILM_SPECULARSCALE, _CHANNEL_G)) 
        return GetTexChannelValue(tex, CHANNEL_G);
    #elif defined(MERGE_NAME(_ILM_SPECULARSCALE, _CHANNEL_B))  
        return GetTexChannelValue(tex, CHANNEL_B);
    #elif defined(MERGE_NAME(_ILM_SPECULARSCALE, _CHANNEL_A))
        return GetTexChannelValue(tex, CHANNEL_A);
    #endif
#else
    return GetTexChannelValue(tex, defaultChannel);
#endif
}
half GetILMShadowThreshold(half4 tex, half4 defaultChannel)
{
#if defined(_ENABLE_CUSTOM_TEX_CHANNEL)
    #if   defined(MERGE_NAME(_ILM_SHADOWTHRESHOLD, _CHANNEL_R)) 
        return GetTexChannelValue(tex, CHANNEL_R);
    #elif defined(MERGE_NAME(_ILM_SHADOWTHRESHOLD, _CHANNEL_G)) 
        return GetTexChannelValue(tex, CHANNEL_G);
    #elif defined(MERGE_NAME(_ILM_SHADOWTHRESHOLD, _CHANNEL_B))  
        return GetTexChannelValue(tex, CHANNEL_B);
    #elif defined(MERGE_NAME(_ILM_SHADOWTHRESHOLD, _CHANNEL_A))
        return GetTexChannelValue(tex, CHANNEL_A);
    #endif
#else
    return GetTexChannelValue(tex, defaultChannel);
#endif
}
half GetILMEmission(half4 tex, half4 defaultChannel)
{
#if defined(_ENABLE_CUSTOM_TEX_CHANNEL)
    #if   defined(MERGE_NAME(_ILM_EMISSION, _CHANNEL_R))
        return GetTexChannelValue(tex, CHANNEL_R);
    #elif defined(MERGE_NAME(_ILM_EMISSION, _CHANNEL_G))
        return GetTexChannelValue(tex, CHANNEL_G);
    #elif defined(MERGE_NAME(_ILM_EMISSION, _CHANNEL_B)) 
        return GetTexChannelValue(tex, CHANNEL_B);
    #elif defined(MERGE_NAME(_ILM_EMISSION, _CHANNEL_A))
        return GetTexChannelValue(tex, CHANNEL_A);
    #endif
#else
    return GetTexChannelValue(tex, defaultChannel);
#endif
}

#endif // SNOWYOWL_TEXTURE_CHANNEL_UTILS_INCLUDE