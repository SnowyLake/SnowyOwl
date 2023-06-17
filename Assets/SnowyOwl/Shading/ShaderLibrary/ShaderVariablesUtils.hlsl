#ifndef SNOWYOWL_SHADER_VARIABLES_UTILS_INCLUDED
#define SNOWYOWL_SHADER_VARIABLES_UTILS_INCLUDED

CBUFFER_START(OwlCustomTextureChannel)
    half4 _SpacularChannel;
    half4 _SmoothnessChannel;
    half4 _ShadowThresholdChannel;
    half4 _EmissiveChannel;
CBUFFER_END


inline half GetValueByTexChannel(half4 tex, half4 channel)
{
    return dot(tex, channel);
}

#endif // SNOWYOWL_SHADER_VARIABLES_UTILS_INCLUDE