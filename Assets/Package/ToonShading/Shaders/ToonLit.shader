Shader "SnowyOwl/ToonLit"
{
    Properties
    {
        [Main(Group_ToonSurface, _, off, off)] _Group_ToonSurface ("Toon Surface Setting", float) = 0
            [Tex(Group_ToonSurface, _BaseColor)] [MainTexture] _BaseMap ("Base Map", 2D) = "white" { }
            [HideInInspector][HDR] _BaseColor ("Base Color", Color) = (1, 1, 1, 1)
            [Tex(Group_ToonSurface)] _ILMMap ("ILM Map", 2D) = "white" { }
            [Channel(Group_ToonSurface)] _SmoothnessChannel ("【Smoothness】Channel", Vector) = (1, 0, 0, 0)
            [Sub(Group_ToonSurface)] _SmoothnessScale ("【Smoothness】Scale", Range(0.0, 2.0)) = 1.0
            [Channel(Group_ToonSurface)] _SpacularScaleChannel ("【SpacularScale】Channel", Vector) = (0, 1, 0, 0)
            [Sub(Group_ToonSurface)] _SpacularScaleScale ("【SpacularScale】Scale", Range(0.0, 2.0)) = 1.0
            [Channel(Group_ToonSurface)] _ShadowThresholdChannel ("【ShadowThreshold】Channel", Vector) = (0, 0, 1, 0)
            [Sub(Group_ToonSurface)] _ShadowThresholdScale ("【ShadowThreshold】Scale", Range(0.0, 2.0)) = 1.0
            [Channel(Group_ToonSurface)] _EmissiveChannel ("【Emissive】Channel", Vector) = (0, 0, 0, 1)
            [Sub(Group_ToonSurface)] _EmissiveScale ("【Emissive】Scale", Range(0.0, 2.0)) = 1.0

            [SubToggle(Group_ToonSurface, _NORMALMAP)] _UseNormalMap("Use Normal Map", Float) = 0.0
                [Tex(Group_ToonSurface_NORMALMAP, _NormalScale)] _NormalMap ("Normal Map", 2D) = "bump" { }
                [HideInInspector] _NormalScale ("Normal Scale", Float) = 1.0

        [Main(Group_Shadow, _, off, off)] _Group_Shadow ("Shadow Setting", float) = 0
            [Title(Group_Shadow, Shadow Color)]
            [KWEnum(Group_Shadow, SSS, _SSSMAP, Ramp, _RAMPMAP)] _ShadowColorType("ShadowColor Type", Float) = 0.0
            [Tex(Group_Shadow_SSSMAP, _ShadowColor)] _SSSMap ("SSS Map", 2D) = "white" { }
            [Tex(Group_Shadow_RAMPMAP, _ShadowColor)] _RampMap ("Ramp Map", 2D) = "white" { }
            //[SubToggle(Group_Shadow_SSSMAP, _RECEIVE_SHADOWS_OFF)]
            [HideInInspector][HDR] _ShadowColor ("Shadow Color", Color) = (1, 1, 1, 1)
            [Title(Group_Shadow, Shadow Option)]
            [SubToggle(Group_Shadow, _RECEIVE_SHADOWS_OFF)] _DisableReceiveShadows("Disable Receive Shadows", Float) = 0.0

        [Main(Group_Mask, _MASKMAP)] _Group_Mask ("Mask Setting", float) = 0
            [Tex(Group_Mask)] _MaskMap ("Mask Map", 2D) = "white" { }
            [Title(Group_Mask, Mask Channel)]
            [Channel(Group_Mask)] _BRDFMaskChannel ("【BRDF Mask】Channel", Vector) = (1, 0, 0, 0)
            [Channel(Group_Mask)] _RimMaskChannel ("【Rim Mask】Channel", Vector) = (0, 1, 0, 0)
            [Channel(Group_Mask)] _MatcapMaskChannel ("【Matcap Mask】Channel", Vector) = (0, 0, 1, 0)
            [Channel(Group_Mask)] _UnusedMaskChannel ("【Unused Mask】Channel", Vector) = (0, 0, 0, 1)

        [Main(Group_BRDF, _BRDFMAP)] _Group_BRDF ("BRDF Setting", float) = 0
            [Tex(Group_BRDF)] _BRDFMap ("BRDF Map", 2D) = "white" { }
            [Channel(Group_BRDF)] _BRDFMetallicChannel ("【BRDF Metallic】Channel", Vector) = (1, 0, 0, 0)
            [Sub(Group_BRDF)] _BRDFMetallicScale ("【BRDF Metallic】Scale", Range(0.0, 1.0)) = 0.0
            [Channel(Group_BRDF)] _BRDFSmoothnessChannel ("【BRDF Smoothness】Channel", Vector) = (0, 1, 0, 0)
            [Sub(Group_BRDF)] _BRDFSmoothnessScale ("【BRDF Smoothness】Scale", Range(0.0, 1.0)) = 0.5
            [Channel(Group_BRDF)] _BRDFOcclusionChannel ("【BRDF Occlusion】Channel", Vector) = (0, 0, 1, 0)
            [Sub(Group_BRDF)] _BRDFOcclusionScale ("【BRDF Occlusion】Scale", Range(0.0, 1.0)) = 1.0
            [Channel(Group_BRDF)] _BRDFEmissiveChannel ("【BRDF Emissive】Channel", Vector) = (0, 0, 0, 1)
            [Sub(Group_BRDF)] _BRDFEmissiveScale ("【BRDF Emissive】Scale", Range(0.0, 1.0)) = 1.0
            
            [Sub(Group_BRDF)] _SpecularColor ("Specular Color", Color) = (0.2, 0.2, 0.2)
            [SubToggle(Group_BRDF, _SPECULARHIGHLIGHTS_OFF)] _DisableSpecularHighlights ("Disable Specular Highlights", Float) = 0.0

        [Main(Group_Rim, _RIM_ON)] _RimLight ("RimLight Setting", float) = 0
            [Sub(Group_Emission)] [HDR] _RimColor ("Color", Color) = (0, 0, 0)
        
        [Main(Group_Outline, _OUTLINE_ON)] _Outline ("Outline Setting", float) = 0
            [Sub(Group_Outline)] _OutlineColor ("Outline Color", Color) = (0, 0, 0, 1)
            [Sub(Group_Outline)] _OutlineWidth ("Outline Width", range(0.0, 1.0)) = 0.04

        // SRP batching compatibility for Clear Coat (Not used in Lit)
        [HideInInspector] _ClearCoatMask("_ClearCoatMask", Float) = 0.0
        [HideInInspector] _ClearCoatSmoothness("_ClearCoatSmoothness", Float) = 0.0

        [Main(Group_General, _, off, off)] _Group_General ("General Setting", float) = 0
            [Sub(Group_General)] _Cutoff ("Alpha Cutoff", Range(0.0, 1.0)) = 0.5
        // Blending state
        _Surface("__surface", Float) = 0.0
        _Blend("__blend", Float) = 0.0
        _Cull("__cull", Float) = 2.0
        [ToggleUI] _AlphaClip("__clip", Float) = 0.0
        [HideInInspector] _SrcBlend("__src", Float) = 1.0
        [HideInInspector] _DstBlend("__dst", Float) = 0.0
        [HideInInspector] _ZWrite("__zw", Float) = 1.0
        // Editmode props
        _QueueOffset("Queue offset", Float) = 0.0

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
            Name "ToonForwardLit"
            Tags{"LightMode" = "UniversalForward"}

            Blend[_SrcBlend][_DstBlend]
            ZWrite[_ZWrite]
            Cull[_Cull]

            HLSLPROGRAM
            #pragma exclude_renderers gles gles3 glcore
            #pragma target 4.5

            // -------------------------------------
            // Toon Material Keywords
            #pragma shader_feature_local _MASKMAP
            #pragma shader_feature_local _BRDFMAP
            #pragma shader_feature_local _SSSMAP _RAMPMAP
            #pragma shader_feature_local _RIM_ON
            #pragma shader_feature_local _OUTLINE_ON

            // -------------------------------------
            // Material Keywords
            #pragma shader_feature_local _NORMALMAP

            #pragma shader_feature_local _RECEIVE_SHADOWS_OFF
            #pragma shader_feature_local_fragment _SURFACE_TYPE_TRANSPARENT
            #pragma shader_feature_local_fragment _ALPHATEST_ON
            #pragma shader_feature_local_fragment _ALPHAPREMULTIPLY_ON
            #pragma shader_feature_local_fragment _EMISSION
            #pragma shader_feature_local_fragment _OCCLUSIONMAP
            #pragma shader_feature_local_fragment _SPECULARHIGHLIGHTS_OFF

            // -------------------------------------
            // Universal Pipeline keywords
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
            #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
            #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
            #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
            #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
            #pragma multi_compile_fragment _ _SHADOWS_SOFT
            #pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
            //#pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
            #pragma multi_compile_fragment _ _LIGHT_LAYERS
            #pragma multi_compile_fragment _ _LIGHT_COOKIES
            #pragma multi_compile _ _CLUSTERED_RENDERING

            // -------------------------------------
            // Unity defined keywords
            #pragma multi_compile_fog
            #pragma multi_compile_fragment _ DEBUG_DISPLAY

            //--------------------------------------
            // GPU Instancing
            // #pragma multi_compile_instancing
            // #pragma instancing_options renderinglayer
            // #pragma multi_compile _ DOTS_INSTANCING_ON

            #pragma vertex LitPassVertex
            //#pragma fragment LitPassFragment
            #pragma fragment Frag
            

            #include "Packages/com.unity.render-pipelines.universal/Shaders/LitInput.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Shaders/LitForwardPass.hlsl"

            half4 Frag(Varyings input) : SV_Target
            {
            #if defined(_SHADOWCOLOR_RAMP)
                return half4(1,0,0,1);
            #else
                return half4(0,1,0,1);
            #endif
            }
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
    //CustomEditor "UnityEditor.Rendering.Universal.ShaderGUI.LitShader"
    CustomEditor "LWGUI.LWGUI"
}
