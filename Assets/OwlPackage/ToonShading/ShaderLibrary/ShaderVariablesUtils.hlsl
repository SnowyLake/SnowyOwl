#ifndef SNOWYOWL_SHADER_VARIABLES_UTILS_INCLUDED
#define SNOWYOWL_SHADER_VARIABLES_UTILS_INCLUDED

inline half GetValueByTexChannel(half4 tex, half4 channel)
{
    return dot(tex, channel);
}

#endif // SNOWYOWL_SHADER_VARIABLES_UTILS_INCLUDE