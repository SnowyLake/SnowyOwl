Shader "SnowyCore/gbuffer"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "LightMode"="gbuffer" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            //#pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            void frag (
                v2f i,
                out float4 GT0 : SV_Target0,
                out float4 GT1 : SV_Target1,
                out float4 GT2 : SV_Target2,
                out float4 GT3 : SV_Target3
                )
            {
                // sample the texture
                float3 color = tex2D(_MainTex, i.uv).rgb;
                float3 normal = i.normal;

                GT0 = float4(color, 1);
                GT1 = float4(normal * 0.5 + 0.5, 0);
                GT2 = float4(1, 1, 0, 1);
                GT3 = float4(0, 0, 1, 1);
            }
            ENDCG
        }
    }
}
