Shader "SnowyOwl/Character/ToonLit"
{
    Properties
    {
        _MaterialCommonSetting("# Material Common Setting", float) = 0
//            [Toggle(_USE_DEBUG_FRAGMENT)] _UseDebugFragment("Use Debug Fragment", Float) = 0.0

            [Toggle] _ZWrite("ZWrite", Float) = 1.0
            [Toggle(_SURFACE_TYPE_TRANSPARENT)] _IsTransparent("Is Transparent", Float) = 0.0
            [Toggle(_ALPHATEST_ON)] _AlphaClip("Alpha Clip", Float) = 0.0
                _Cutoff("Alpha Cutoff [_ALPHATEST_ON]", Range(0.0, 1.0)) = 0.5
            [Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend("SrcBlend", Float) = 1.0
            [Enum(UnityEngine.Rendering.BlendMode)] _DstBlend("DstBlend", Float) = 0.0
            [Enum(UnityEngine.Rendering.CullMode)] _Cull("Cull Mode", Float) = 2.0
            [Enum(RGBA, 15, RGB, 14)]_ColorMask("ColorMask Mode", Float) = 15 // 15 is RGBA (binary 1111)
            [Toggle(_RECEIVE_SHADOWS_OFF)] _DisableReceiveShadows("Disable Receive Shadows", Float) = 0.0
            [Toggle(_SPECULARHIGHLIGHTS_OFF)] _DisableSpecularHighlights("Disable Specular Highlights", Float) = 0.0
            [Toggle(_ENVIRONMENTREFLECTIONS_OFF)] _DisableEnvironmentReflections("Disable Environment Reflections", Float) = 0.0

        _ToonSurfaceSetting("# Toon Surface", float) = 0
            [HDR] _BaseColor("Base Color", Color) = (1, 1, 1, 1)
            [MainTexture] _BaseMap("Base Map", 2D) = "white" { }
            _DiffuseStepSmoothness("Diffuse Step Smoothness", Range(0.01, 1)) = 0.01
            _DiffuseStepSmoothnessOffset("Diffuse Step Smoothness Offset", Range(0, 1)) = 0
            
        _ToonShadingSetting("# Toon Shading", float) = 0
            _ILMChannnelNOTE("!NOTE Channnel: R - SpacularScale,  G - Smoothness,  B - ShadowThreshold,  A - Emission", float) = 0
            _ILMMap("ILM Map &", 2D) = "gary" { }
            _SpecularColor("Specular Color", Color) = (1, 1, 1, 1)
            _SpacularScale("Spacular Scale", Range(0.0, 2.0)) = 1.0
            _Smoothness("Smoothness", Range(0.0,  2.0)) = 0.5
            _EmissionColor("Emission Color", Color) = (1, 1, 1, 1)
            _EmissionScale("Emission Scale", Range(0, 100)) = 0
        
        _ToonShadowSetting("# Toon Shadow", float) = 0
            [KeywordEnum(None, SSS, SSS Ramp, MultiColor Ramp)] _ShadowMap("ShadowMap Type", Float) = 0.0
                _ShadowSSSMap("SSS Map & [_SHADOWMAP_SSS || _SHADOWMAP_SSS_RAMP]", 2D) = "white" { }
                _ShadowRampMap("Ramp Map & [_SHADOWMAP_SSS_RAMP || _SHADOWMAP_MULTICOLOR_RAMP]", 2D) = "white" { }
            _ShadowColor("Shadow Color", Color) = (1, 1, 1, 1)
            _ShadowScale("Shadow Scale", Range(0, 1)) = 1
            [Toggle(_HQ_SELF_SHADOWS_ON)] _EnableHQSelfShadows("Enable HQ Self Shadows", Float) = 0.0
    
        _NormalSetting ("# Normal Setting", float) = 0
            [Toggle(_NORMALMAP)] _EnableNormalMap("Enable Normal Map", Float) = 0.0
            _BumpMap("Normal Map && [_NORMALMAP]", 2D) = "bump" { }
            _BumpScale("Normal Scale [_NORMALMAP]", range(0.0, 10.0)) = 1.0
        
        _GISetting("# GI Setting", float) = 0
            _GIScale("GI Scale", Range(0.0, 1.0)) = 0.5

        _OutlineSetting ("# Outline", float) = 0
            _OutlineColor("Outline Color", Color) = (0.1, 0.1, 0.1, 1)
            _OutlineWidth("Outline Width", Range(0.001, 0.1)) = 0.005
            [Toggle(_OUTLINE_SMOOTHEDNORMAL)] _EnableSmoothNormal("Enable Smooth Normal",Float) = 0
            [Toggle(_OUTLINE_INNER_ON)] _EnableInnerOutLine("Enable Inner OutLine", Float) = 0
        
        _RimLightSetting("# RimLight", float) = 0
            [KeywordEnum(OFF, Fresnel, DepthOffset)] _Rim("RimLight Mode", Float) = 0.0
            _RimColor("Rim Color [!_RIM_OFF]", Color) = (1, 1, 1, 1)
        
        _MatcapSetting ("# Matcap", float) = 0
            [KeywordEnum(OFF, Add, Mul)] _Matcap("Matcap Mode", Float) = 0.0
            _MatcapMap("Matcap Map & [!_MATCAP_OFF]", 2D) = "white" { }
        
        _MaskSetting ("# Mask", float) = 0
            [Toggle(_MASKMAP_ON)] _UseMaskMap("Use Mask Map",Float) = 0.0
            _MaskChannnelNOTE("!NOTE Channnel: R - BRDFMask,  G - RimLightMask,  B - MatcapMask,  A - Unused [_MASKMAP_ON]", float) = 0
            _MaskMap("Mask Map & [_MASKMAP_ON]", 2D) = "white" { }
        _BRDFSetting ("# BRDF", float) = 0
            [Toggle(_BRDFMAP_ON)] _UseBRDFMap("Use BRDF Map", Float) = 0.0
            _BRDFChannnelNOTE("!NOTE Channnel: R - Metallic,  G - Smoothness,  B - Occlusion,  A - Emission [_BRDFMAP_ON]", float) = 0
            _BRDFMap("BRDF Map & [_BRDFMAP_ON]", 2D) = "white" { }
            _BRDFScale("BRDF Scale (Metallic, Smoothness, Occlusion, Emission) & [_BRDFMAP_ON]", Vector) = (0, 0.5, 1.0, 1.0)
    }

    SubShader
    {
        // Universal Pipeline tag is required. If Universal render pipeline is not set in the graphics settings
        // this Subshader will fail. One can add a subshader below or fallback to Standard built-in to make this
        // material work with both Universal Render Pipeline and Builtin Unity Pipeline
        Tags
        {
            "RenderType" = "Opaque"
            "RenderPipeline" = "UniversalPipeline"
            "UniversalMaterialType" = "ToonLit"
            "IgnoreProjector" = "True"
        }
        LOD 300

        // ------------------------------------------------------------------
        //  Forward pass. Shades all light in a single pass. GI + emission + Fog
        Pass
        {
            // Lightmode matches the ShaderPassName set in UniversalRenderPipeline.cs. SRPDefaultUnlit and passes with
            // no LightMode tag are also rendered by Universal Render Pipeline
            Name "ToonLitForward"
            Tags{"LightMode" = "UniversalForward"}

            Cull[_Cull]
            Blend[_SrcBlend][_DstBlend]
            ZWrite[_ZWrite]
            ColorMask [_ColorMask]

            HLSLPROGRAM
            #pragma target 4.5
            // #pragma enable_d3d11_debug_symbols
            
            #pragma shader_feature_local _USE_DEBUG_FRAGMENT

            // -------------------------------------
            // SnowyOwl Material Keywords
            #pragma shader_feature_local _SHADOWMAP_NONE _SHADOWMAP_SSS _SHADOWMAP_SSS_RAMP _SHADOWMAP_MULTICOLOR_RAMP
            #pragma shader_feature_local _HQ_SELF_SHADOWS_ON
            #pragma shader_feature_local _OUTLINE_INNER_ON
            #pragma shader_feature_local _MASKMAP_ON
            #pragma shader_feature_local _BRDFMAP_ON
            #pragma shader_feature_local _RIM_OFF _RIM_FRESNEL _RIM_DEPTHOFFSET
            #pragma shader_feature_local _MATCAP_OFF _MATCAP_ADD _MATCAP_MUL

            // -------------------------------------
            // Material Keywords
            #pragma shader_feature_local _NORMALMAP
            #pragma shader_feature_local _SURFACE_TYPE_TRANSPARENT
            #pragma shader_feature_local _ALPHATEST_ON
            #pragma shader_feature_local _RECEIVE_SHADOWS_OFF
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

            #pragma vertex ToonLitForwardVertex
            #pragma fragment ToonLitForwardFragment
            
            #include "../Include/Character/ToonLitPass.hlsl"
            ENDHLSL
        }

        Pass // Outline Pass
        {
            Name "Outline"
            Tags{"LightMode" = "Outline"}

            Blend SrcAlpha OneMinusSrcAlpha
            Cull front

            HLSLPROGRAM

            #pragma shader_feature_local _OUTLINE_SMOOTHEDNORMAL
            #pragma shader_feature_local _ALPHATEST_ON

            #pragma multi_compile_fog

            #pragma vertex OutlinePassVertex
            #pragma fragment OutlinePassFragment

            #include "../Include/Character/ToonLitPass.hlsl"

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
