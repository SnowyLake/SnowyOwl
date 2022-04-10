#define PI 3.14159265359

// BRDF

// D: D(N, H, a), Normal Distribution Function
//--------------------------------------------
// N: Normal
// H: Halfway Vector
// a: Roughness
//--------------------------------------------
float Trowbridge_Reitz_GGX(float NdotH, float a)
{
    float a2 = a * a;
    float NdotH2 = NdotH * NdotH;

    float nom = a2;
    float denom = (NdotH2 * (a2 - 1.0) + 1.0);
    denom = PI * denom * denom;

    return nom / denom;
}

// F: F(H, V, F0), Fresnel Equation
//---------------------------------
// H: Halfway Vector
// V: View Vector
// F0: Surface base Reflectance
//---------------------------------
float SchlickFresnel(float HdotV, float3 F0)
{
    float m = clamp(1- HdotV, 0.0, 1.0);
    float m5 = pow(m, 5);
    return F0 + (1 - F0) * m5;
}

// G: G(N, V, k), Geometry Function
//------------------------------------
// N: Normal
// V: View Vector
// k: (roughness + 1) ^ 2 / 8 (direct)
//------------------------------------
float SchilckGGX(float NdotV, float k)
{
    float nom = NdotV;
    float denom = NdotV * (1.0 - k) + k;

    return nom / denom;
}

// Unity use this as IBL F
float3 SchlickFresnelRoughness(float NdotV, float f0, float roughness)
{
    float r1 = 1.0f - roughness;
    return f0 + (max(float3(r1, r1, r1), f0) - f0) * pow(1 - NdotV, 5.0f);
}

float3 PBR(float3 N, float3 V, float3 L, float3 albedo, float3 radiance, float roughness, float metallic)
{
    roughness = max(roughness, 0.05);   //保证光滑物体也有高光
    float3 H = normalize(L + V);
    float  NdotL = max(dot(N, L), 0);
    float  NdotV = max(dot(N, V), 0);
    float  NdotH = max(dot(N, H), 0);
    float  HdotV = max(dot(H, V), 0);
    float  alpha = roughness * roughness;
    float  k     = (alpha + 1) * (alpha + 1) / 8;
    float3 F0    = lerp(float3(0.04, 0.04, 0.04), albedo, metallic);

    float  D = Trowbridge_Reitz_GGX(NdotH, alpha);
    float3 F = SchlickFresnel(HdotV, F0);
    float  G = SchilckGGX(NdotV, k) * SchilckGGX(NdotL, k);

    float3 ks = F;
    float3 kd = (1.0 - ks) * (1.0 - metallic);
    float3 diffuse  = albedo / PI;
    float3 specular = (D * F * G) / (4.0 * NdotV * NdotL + 0.0001);

    diffuse *= PI;
    specular *= PI;

    float3 Lo = (kd * diffuse + specular) * radiance * NdotL;
    return Lo;
}

float3 IBL(float3 N, float3 V, float3 albedo, float roughness, float metallic,
        samplerCUBE _diffuseIBL, samplerCUBE _specularIBL, sampler2D _brdfIBL)
{
    roughness = min(roughness, 0.99);
    float3 H = normalize(N);    // 法向量作为半角向量
    float  NdotV = max(dot(N, V), 0);
    float  HdotV = max(dot(H, V), 0);
    float3 R = normalize(reflect(-V, N));

    float3 F0 = lerp(float(0.04), albedo, metallic);
    float3 F  = SchlickFresnelRoughness(HdotV, F0, roughness);
    float3 ks = F;
    float3 kd = (1.0 - ks) * (1.0 - metallic);

    // diffuse
    float3 IBLd = texCUBE(_diffuseIBL, N).rgb;
    float3 diffuse = kd * albedo * IBLd;

    // specular
    float  rgh = roughness * (1.7 - 0.7 * roughness);
    float  lod = 6.0f * rgh;     // 6级mipmap
    float3 IBLs = texCUBElod(_specularIBL, float4(R, lod)).rgb;
    float2 brdf = tex2D(_brdfIBL, float2(NdotV, roughness)).rg;
    float3 specular = IBLs * (F0 * brdf.x + brdf.y);

    float3 ambient = diffuse + specular;
    return ambient;
}