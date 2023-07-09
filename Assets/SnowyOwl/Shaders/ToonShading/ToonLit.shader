Shader "SnowyOwl/SceneRendering/ToonLit"
{
    Properties
    {
        _PreMaterialSetting("# Pre Material Setting", float) = 0
            [Toggle(_ENABLE_CUSTOM_TEX_CHANNEL)] _EnbaleCustomTextureChannel("Enbale Custom Texture Channel", Float) = 1.0
            [Toggle(_USE_DEBUG_FRAGMENT)] _UseDebugFragment("Use Debug Fragment", Float) = 0.0

        _ToonSurfaceSetting("# Toon Surface", float) = 0
                [HDR] _BaseColor("Base Color", Color) = (1, 1, 1, 1)
                [MainTexture] _BaseMap("Base Map", 2D) = "white" { }
            
            _ToonSpecularSetting("## Toon Specular Setting", float) = 0
                _ILMMap("ILM Map &", 2D) = "white" { }
                _ILMDefaultChannnel("!NOTE Default Channnel: R - Smoothness,  G - SpacularScale,  B - ShadowThreshold,  A - Emission", float) = 0
                    _ILMCustomChannnel1("--!DRAWER MultiProperty _ILM_Smoothness _ILM_SpacularScale [_ENABLE_CUSTOM_TEX_CHANNEL]", float) = 0.0
                        [KeywordEnum(Channel R, Channel G, Channel B, Channel A)] _ILM_Smoothness("Smoothness Channel", float) = 0.0
                        [KeywordEnum(Channel R, Channel G, Channel B, Channel A)] _ILM_SpacularScale("SpacularScale Channel", float) = 1.0
                    _ILMCustomChannnel2("--!DRAWER MultiProperty _ILM_ShadowThreshold _ILM_Emission [_ENABLE_CUSTOM_TEX_CHANNEL]", float) = 0.0
                        [KeywordEnum(Channel R, Channel G, Channel B, Channel A)] _ILM_ShadowThreshold("ShadowThreshold Channel", float) = 2.0
                        [KeywordEnum(Channel R, Channel G, Channel B, Channel A)] _ILM_Emission("Emission Channel", float) = 3.0

                _Smoothness("Smoothness", Range(1,  1024)) = 64                       
                _SpacularScale("SpacularScale", Range(0.0, 2.0)) = 1.0
                _CustomSpecularColor("Custom Specular Color", Color) = (1, 1, 1, 1)
                _CustomSpecularColorWeight("Custom Specular Color Weight", Range(0.0, 1.0)) = 0.5
                [Toggle(_SPECULARHIGHLIGHTS_OFF)] _DisableSpecularHighlights("Disable Specular Highlights", Float) = 0.0
            
            _ToonShadowSetting("## Toon Shadow Setting", float) = 0
                _ShadowThreshold("ShadowThreshold", Range(0.0, 2.0)) = 1.0
                _ShadowColor("Shadow Color", Color) = (1, 1, 1, 1)
                [KeywordEnum(None, SSS, SSS Ramp, MultiColor Ramp)] _ShadowMap("ShadowMap Type", Float) = 0.0
                    _ShadowSSSMap("-SSS Map & [_SHADOWMAP_SSS || _SHADOWMAP_SSS_RAMP]", 2D) = "white" { }
                    _ShadowSSSRampMapGenerator("-!DRAWER Gradient _ShadowSSSRampMap [_SHADOWMAP_SSS_RAMP]", float) = 0
                        _ShadowSSSRampMap("SSS RampMap [_SHADOWMAP_SSS_RAMP]", 2D) = "white" { }
                    _ShadowSSSRampScale("-SSS Ramp Scale [_SHADOWMAP_SSS_RAMP]", Range(0.0, 1.0)) = 0.0
                    _ShadowRampMap("Ramp Map & [_SHADOWMAP_MULTICOLOR_RAMP]", 2D) = "white" { }
                [Toggle(_HIGHQUALITY_SELF_SHADOWS_ON)] _EnableHQSelfShadows("Enable HQ Self Shadows", Float) = 0.0

            _GIAndEmissionSetting("## GI and Emission Setting", float) = 0
                _GIScale("GI Scale", Range(0.0, 1.0)) = 0.5
                [Toggle(_EMISSION)] _Emission("Enable Emission", Float) = 0.0
                [HDR] _EmissionColor("Emission Color [_EMISSION]", Color) = (1, 1, 1, 1)
                _EmissionScale("Emission Scale [_EMISSION]", Range(0.0, 1.0)) = 0.0

            _NormalSetting ("## Normal Setting", float) = 0
                [Toggle(_NORMALMAP)] _UseNormalMap("Use Normal Map", Float) = 0.0
                _BumpMap("Normal Map && [_NORMALMAP]", 2D) = "bump" { }
                _BumpScale("Normal Scale [_NORMALMAP]", range(0.0, 10.0)) = 1.0

        _OutlineSetting ("# Outline", float) = 0
            [Toggle(_OUTLINE_ON)] _EnableOutLine("Enable OutLine", Float) = 0.0
            _OutlineColor("Outline Color [_OUTLINE_ON]", Color) = (0, 0, 0, 1)
            _OutlineWidth("Outline Width [_OUTLINE_ON]", range(0.0, 1.0)) = 0.2
            [Toggle(_OUTLINE_INNER_ON)] _EnableInnerOutLine("Enable Inner OutLine [_OUTLINE_ON]", Float) = 0.0

        _MaskSetting ("# Mask", float) = 0
            [Toggle(_MASKMAP_ON)] _UseMaskMap("Use Mask Map", Float) = 0.0
            _MaskMap("Mask Map & [_MASKMAP_ON]", 2D) = "white" { }
            _ILMDefaultChannnel("!NOTE Default Channnel: R - BRDFMask,  G - RimLightMask,  B - MatcapMask,  A - Unused [_MASKMAP_ON]", float) = 0
                _MaskCustomChannnel1("--!DRAWER MultiProperty _Mask_BRDF _Mask_RIM [_ENABLE_CUSTOM_TEX_CHANNEL && _MASKMAP_ON]", float) = 0.0
                    [KeywordEnum(Channel R, Channel G, Channel B, Channel A)] _Mask_BRDF("BRDF Mask Channel", float) = 0.0
                    [KeywordEnum(Channel R, Channel G, Channel B, Channel A)] _Mask_RIM("RimLight Mask Channel", float) = 1.0
                _MaskCustomChannnel2("--!DRAWER MultiProperty _Mask_MATCAP _Mask_Unused [_ENABLE_CUSTOM_TEX_CHANNEL && _MASKMAP_ON]", float) = 0.0
                    [KeywordEnum(Channel R, Channel G, Channel B, Channel A)] _Mask_MATCAP("Matcap Mask Channel", float) = 2.0
                    [KeywordEnum(Channel R, Channel G, Channel B, Channel A)] _Mask_Unused("Unused Mask Channel", float) = 3.0

        _BRDFSetting ("# BRDF", float) = 0
            [Toggle(_BRDFMAP_ON)] _UseBRDFMap("Use BRDF Map", Float) = 0.0
            _BRDFMap("BRDF Map & [_BRDFMAP_ON]", 2D) = "white" { }
            _BRDFDefaultChannnel("!NOTE Default Channnel: R - Metallic,  G - Smoothness,  B - Occlusion,  A - Emission [_BRDFMAP_ON]", float) = 0
            _BRDFScale("BRDF Scale (Metallic, Smoothness, Occlusion, Emission) & [_BRDFMAP_ON]", Vector) = (0, 0.5, 1.0, 1.0)

        _RimLightSetting("# RimLight", float) = 0
            [KeywordEnum(OFF, Fresnel, DepthOffset)] _Rim("RimLight Mode", Float) = 0.0
            _RimColor("Rim Color [!_RIM_OFF]", Color) = (1, 1, 1, 1)
        
        _MatcapSetting ("# Matcap", float) = 0
            [KeywordEnum(OFF, Add, Mul)] _Matcap("Matcap Mode", Float) = 0.0
            _MatcapMap("Matcap Map & [!_MATCAP_OFF]", 2D) = "white" { }

        _MaterialGeneralSetting ("# Material General", float) = 0
            [Toggle(_ALPHATEST_ON)] _AlphaClip("Alpha Clip", Float) = 0.0
            _Cutoff("Alpha Cutoff [_ALPHATEST_ON]", Range(0.0, 1.0)) = 0.5
            [Toggle(_SURFACE_TYPE_TRANSPARENT)] _IsTransparent("Is Transparent", Float) = 0.0
            [Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend("SrcBlend", Float) = 1.0
            [Enum(UnityEngine.Rendering.BlendMode)] _DstBlend("DstBlend", Float) = 0.0
            [Toggle] _ZWrite("ZWrite", Float) = 1.0
            [Enum(UnityEngine.Rendering.CullMode)] _Cull("Cull Mode", Float) = 2.0
            [Enum(RGBA, 15, RGB, 14)]_ColorMask("ColorMask Mode", Float) = 15 // 15 is RGBA (binary 1111)
            _QueueOffset("Queue Offset", Float) = 0.0 // Editmode props


        // SRP batching compatibility for Clear Coat (Not used in Lit)
        [HideInInspector] _ClearCoatMask("_ClearCoatMask", Float) = 0.0
        [HideInInspector] _ClearCoatSmoothness("_ClearCoatSmoothness", Float) = 0.0
        // ObsoleteProperties
        [HideInInspector] _MainTex("BaseMap", 2D) = "white" {}
        [HideInInspector] _Color("Base Color", Color) = (1, 1, 1, 1)
        [HideInInspector] _GlossMapScale("Smoothness", Float) = 0.0
        [HideInInspector] _Glossiness("Smoothness", Float) = 0.0
        [HideInInspector] _GlossyReflections("EnvironmentReflections", Float) = 0.0
    }

    SubShader
    {
        // Universal Pipeline tag is required. If Universal render pipeline is not set in the graphics settings
        // this Subshader will fail. One can add a subshader below or fallback to Standard built-in to make this
        // material work with both Universal Render Pipeline and Builtin Unity Pipeline
        Tags{"RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" "UniversalMaterialType" = "ToonLit" "IgnoreProjector" = "True"}
        LOD 300

        // ------------------------------------------------------------------
        //  Forward pass. Shades all light in a single pass. GI + emission + Fog
        Pass
        {
            // Lightmode matches the ShaderPassName set in UniversalRenderPipeline.cs. SRPDefaultUnlit and passes with
            // no LightMode tag are also rendered by Universal Render Pipeline
            Name "ForwardToonLit"
            Tags{"LightMode" = "UniversalForward"}

            Cull[_Cull]
            Blend[_SrcBlend][_DstBlend]
            ZWrite[_ZWrite]
            ColorMask [_ColorMask]

            HLSLPROGRAM
            #pragma target 4.5
            //#pragma enable_d3d11_debug_symbols

            // -------------------------------------
            // SnowyOwl Common Keywords
            // #pragma multi_compile _ _ALPHATEST_OFF
            #pragma shader_feature_local _USE_DEBUG_FRAGMENT
            #pragma shader_feature_local _ENABLE_CUSTOM_TEX_CHANNEL

            // -------------------------------------
            // SnowyOwl Toon Material Keywords
            #pragma shader_feature_local _SHADOWMAP_NONE _SHADOWMAP_SSS _SHADOWMAP_SSS_RAMP _SHADOWMAP_MULTICOLOR_RAMP
            #pragma shader_feature_local _HIGHQUALITY_SELF_SHADOWS_ON
            #pragma shader_feature_local _MASKMAP_ON
            #pragma shader_feature_local _BRDFMAP_ON
            #pragma shader_feature_local _RIM_OFF _RIM_FRESNEL _RIM_DEPTHOFFSET
            #pragma shader_feature_local _MATCAP_OFF _MATCAP_ADD _MATCAP_MUL
            #pragma shader_feature_local _OUTLINE_ON
            #pragma shader_feature_local _OUTLINE_INNER_ON

            //----------------------------------------------------------------
            // Custom Texture Channel, used in TextureChannelUtils.hlsl
            //----------------------------------------------------------------
            // ILM Map: Smoothness SpecularScale ShadowThresHold Emission
            #pragma shader_feature_local _ILM_SMOOTHNESS_CHANNEL_R _ILM_SMOOTHNESS_CHANNEL_G _ILM_SMOOTHNESS_CHANNEL_B _ILM_SMOOTHNESS_CHANNEL_A
            #pragma shader_feature_local _ILM_SPECULARSCALE_CHANNEL_R _ILM_SPECULARSCALE_CHANNEL_G _ILM_SPECULARSCALE_CHANNEL_B _ILM_SPECULARSCALE_CHANNEL_A
            #pragma shader_feature_local _ILM_SHADOWTHRESHOLD_CHANNEL_R _ILM_SHADOWTHRESHOLD_CHANNEL_G _ILM_SHADOWTHRESHOLD_CHANNEL_B _ILM_SHADOWTHRESHOLD_CHANNEL_A
            #pragma shader_feature_local _ILM_EMISSION_CHANNEL_R _ILM_EMISSION_CHANNEL_G _ILM_EMISSION_CHANNEL_B _ILM_EMISSION_CHANNEL_A
            // Mask Map: BRDF RimLight Matcap Unused
            #pragma shader_feature_local _MASK_BRDF_CHANNEL_R _MASK_BRDF_CHANNEL_G _MASK_BRDF_CHANNEL_B _MASK_BRDF_CHANNEL_A
            #pragma shader_feature_local _MASK_RIM_CHANNEL_R _MASK_RIM_CHANNEL_G _MASK_RIM_CHANNEL_B _MASK_RIM_CHANNEL_A
            #pragma shader_feature_local _MASK_MATCAP_CHANNEL_R _MASK_MATCAP_CHANNEL_G _MASK_MATCAP_CHANNEL_B _MASK_MATCAP_CHANNEL_A
            #pragma shader_feature_local _MASK_UNUSED_CHANNEL_R _MASK_UNUSED_CHANNEL_G _MASK_UNUSED_CHANNEL_B _MASK_UNUSED_CHANNEL_A

            // -------------------------------------
            // Material Keywords
            #pragma shader_feature_local _NORMALMAP
            #pragma shader_feature_local _EMISSION
            #pragma shader_feature_local _SURFACE_TYPE_TRANSPARENT
            #pragma shader_feature_local _ALPHATEST_ON
            #pragma shader_feature_local _ALPHAPREMULTIPLY_ON
            //#pragma shader_feature_local _RECEIVE_SHADOWS_OFF
            #if defined(_HIGHQUALITY_SELF_SHADOWS_ON)
                #define _RECEIVE_SHADOWS_OFF
            #endif
            #pragma shader_feature_local _SPECULARHIGHLIGHTS_OFF
            #pragma shader_feature_local _ENVIRONMENTREFLECTIONS_OFF

            // -------------------------------------
            // Universal Pipeline keywords
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
            #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
            #pragma multi_compile _ EVALUATE_SH_MIXED EVALUATE_SH_VERTEX
            #pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
            #pragma multi_compile _ _REFLECTION_PROBE_BLENDING
            #pragma multi_compile _ _REFLECTION_PROBE_BOX_PROJECTION
            #pragma multi_compile _ _SHADOWS_SOFT
            #pragma multi_compile _ _SCREEN_SPACE_OCCLUSION
            #pragma multi_compile _ _LIGHT_LAYERS
            #pragma multi_compile _ _LIGHT_COOKIES
            #pragma multi_compile _ _FORWARD_PLUS
            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"

            // -------------------------------------
            // Unity defined keywords
            #pragma multi_compile_fog
            #pragma multi_compile_fragment _ LOD_FADE_CROSSFADE
            #pragma multi_compile_fragment _ DEBUG_DISPLAY

            #pragma vertex ToonLitPassVertex
            #pragma fragment Frag
            
            #include "Assets/SnowyOwl/Shaders/ToonShading/ToonLitInput.hlsl"
            #include "Assets/SnowyOwl/Shaders/ToonShading/ToonLitForwardPass.hlsl"

            half4 DebugFragment(Varyings input) : SV_Target
            {
            #if defined(_SHADOWMAP_SSS_RAMP)
                return half4(1,0,0,1);
            #elif defined(_SHADOWMAP_MULTICOLOR_RAMP)
                return half4(0,1,0,1);
            #else
                return half4(0,0,0,1);
            #endif
            }

            half4 Frag(Varyings input) : SV_Target
            {
            #if defined(_USE_DEBUG_FRAGMENT)
                return DebugFragment(input);
            #else
                return ToonLitPassFragment(input);
            #endif
            }

            ENDHLSL
        }

        Pass // Outline Pass
        {
            Name "Outline"
            Tags{"LightMode" = "Outline"}

            Cull front
            // ZTest Less
            // ZWrite Off

            HLSLPROGRAM

            #pragma shader_feature_local _OUTLINE_ON
            #pragma shader_feature_local_fragment _ALPHATEST_ON

            #pragma multi_compile_fog

            #pragma vertex OutlinePassVertex
            #pragma fragment OutlinePassFragment

            #include "Assets/SnowyOwl/Shaders/ToonShading/ToonLitInput.hlsl"
            #include "Assets/SnowyOwl/Shaders/ToonShading/OutlinePass.hlsl"

            ENDHLSL
        }
        Pass // ShadowCaster Pass
        {
            Name "ShadowCaster"
            Tags{"LightMode" = "ShadowCaster"}

            ZWrite On
            ZTest LEqual
            ColorMask 0
            Cull[_Cull]

            HLSLPROGRAM
            #pragma exclude_renderers gles gles3 glcore
            #pragma target 4.5

            // -------------------------------------
            // Material Keywords
            #pragma shader_feature_local_fragment _ALPHATEST_ON
            #pragma shader_feature_local_fragment _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A

            //--------------------------------------
            // GPU Instancing
            #pragma multi_compile_instancing
            #pragma multi_compile _ DOTS_INSTANCING_ON

            // -------------------------------------
            // Universal Pipeline keywords

            // This is used during shadow map generation to differentiate between directional and punctual light shadows, as they use different formulas to apply Normal Bias
            #pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW

            #pragma vertex ShadowPassVertex
            #pragma fragment ShadowPassFragment

            #include "Packages/com.unity.render-pipelines.universal/Shaders/LitInput.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Shaders/ShadowCasterPass.hlsl"
            ENDHLSL
        }

        Pass // GBuffer Pass
        {
            // Lightmode matches the ShaderPassName set in UniversalRenderPipeline.cs. SRPDefaultUnlit and passes with
            // no LightMode tag are also rendered by Universal Render Pipeline
            Name "GBuffer"
            Tags{"LightMode" = "UniversalGBuffer"}

            ZWrite[_ZWrite]
            ZTest LEqual
            Cull[_Cull]

            HLSLPROGRAM
            #pragma exclude_renderers gles gles3 glcore
            #pragma target 4.5

            // -------------------------------------
            // Material Keywords
            #pragma shader_feature_local _NORMALMAP
            #pragma shader_feature_local_fragment _ALPHATEST_ON
            //#pragma shader_feature_local_fragment _ALPHAPREMULTIPLY_ON
            #pragma shader_feature_local_fragment _EMISSION
            #pragma shader_feature_local_fragment _METALLICSPECGLOSSMAP
            #pragma shader_feature_local_fragment _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
            #pragma shader_feature_local_fragment _OCCLUSIONMAP
            #pragma shader_feature_local _PARALLAXMAP
            #pragma shader_feature_local _ _DETAIL_MULX2 _DETAIL_SCALED

            #pragma shader_feature_local_fragment _SPECULARHIGHLIGHTS_OFF
            #pragma shader_feature_local_fragment _ENVIRONMENTREFLECTIONS_OFF
            #pragma shader_feature_local_fragment _SPECULAR_SETUP
            #pragma shader_feature_local _RECEIVE_SHADOWS_OFF

            // -------------------------------------
            // Universal Pipeline keywords
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
            //#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
            //#pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
            #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
            #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
            #pragma multi_compile_fragment _ _SHADOWS_SOFT
            #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
            #pragma multi_compile_fragment _ _LIGHT_LAYERS
            #pragma multi_compile_fragment _ _RENDER_PASS_ENABLED

            // -------------------------------------
            // Unity defined keywords
            #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
            #pragma multi_compile _ SHADOWS_SHADOWMASK
            #pragma multi_compile _ DIRLIGHTMAP_COMBINED
            #pragma multi_compile _ LIGHTMAP_ON
            #pragma multi_compile _ DYNAMICLIGHTMAP_ON
            #pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT

            //--------------------------------------
            // GPU Instancing
            #pragma multi_compile_instancing
            #pragma instancing_options renderinglayer
            #pragma multi_compile _ DOTS_INSTANCING_ON

            #pragma vertex LitGBufferPassVertex
            #pragma fragment LitGBufferPassFragment

            #include "Packages/com.unity.render-pipelines.universal/Shaders/LitInput.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Shaders/LitGBufferPass.hlsl"
            ENDHLSL
        }

        Pass // DepthOnly Pass
        {
            Name "DepthOnly"
            Tags{"LightMode" = "DepthOnly"}

            ZWrite On
            ColorMask 0
            Cull[_Cull]

            HLSLPROGRAM
            #pragma exclude_renderers gles gles3 glcore
            #pragma target 4.5

            #pragma vertex DepthOnlyVertex
            #pragma fragment DepthOnlyFragment

            // -------------------------------------
            // Material Keywords
            #pragma shader_feature_local_fragment _ALPHATEST_ON
            #pragma shader_feature_local_fragment _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A

            //--------------------------------------
            // GPU Instancing
            #pragma multi_compile_instancing
            #pragma multi_compile _ DOTS_INSTANCING_ON

            #include "Packages/com.unity.render-pipelines.universal/Shaders/LitInput.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Shaders/DepthOnlyPass.hlsl"
            ENDHLSL
        }

        // This pass is used when drawing to a _CameraNormalsTexture texture
        Pass // DepthNormals Pass
        {
            Name "DepthNormals"
            Tags{"LightMode" = "DepthNormals"}

            ZWrite On
            Cull[_Cull]

            HLSLPROGRAM
            #pragma exclude_renderers gles gles3 glcore
            #pragma target 4.5

            #pragma vertex DepthNormalsVertex
            #pragma fragment DepthNormalsFragment

            // -------------------------------------
            // Material Keywords
            #pragma shader_feature_local _NORMALMAP
            #pragma shader_feature_local _PARALLAXMAP
            #pragma shader_feature_local _ _DETAIL_MULX2 _DETAIL_SCALED
            #pragma shader_feature_local_fragment _ALPHATEST_ON
            #pragma shader_feature_local_fragment _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A

            //--------------------------------------
            // GPU Instancing
            #pragma multi_compile_instancing
            #pragma multi_compile _ DOTS_INSTANCING_ON

            #include "Packages/com.unity.render-pipelines.universal/Shaders/LitInput.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Shaders/LitDepthNormalsPass.hlsl"
            ENDHLSL
        }

        // This pass it not used during regular rendering, only for lightmap baking.
        Pass // Meta Pass
        {
            Name "Meta"
            Tags{"LightMode" = "Meta"}

            Cull Off

            HLSLPROGRAM
            #pragma exclude_renderers gles gles3 glcore
            #pragma target 4.5

            #pragma vertex UniversalVertexMeta
            #pragma fragment UniversalFragmentMetaLit

            #pragma shader_feature EDITOR_VISUALIZATION
            #pragma shader_feature_local_fragment _SPECULAR_SETUP
            #pragma shader_feature_local_fragment _EMISSION
            #pragma shader_feature_local_fragment _METALLICSPECGLOSSMAP
            #pragma shader_feature_local_fragment _ALPHATEST_ON
            #pragma shader_feature_local_fragment _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
            #pragma shader_feature_local _ _DETAIL_MULX2 _DETAIL_SCALED

            #pragma shader_feature_local_fragment _SPECGLOSSMAP

            #include "Packages/com.unity.render-pipelines.universal/Shaders/LitInput.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Shaders/LitMetaPass.hlsl"

            ENDHLSL
        }
    }

    FallBack "Hidden/Universal Render Pipeline/FallbackError"
    CustomEditor "Needle.MarkdownShaderGUI"
}
