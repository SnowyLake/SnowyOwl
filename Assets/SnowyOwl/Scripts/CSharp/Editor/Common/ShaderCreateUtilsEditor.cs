using UnityEditor;

// Snowy is top-level namespace use for common class/struct.
namespace SnowyOwl
{
    public class ShaderCreateUtilsEditor : Editor
    {
        private const string m_DefaultURPShaderTemplete = "Assets/SnowyOwl/Shaders/Templetes/DefaultURPShaderTemplete.shader";
        [MenuItem("Assets/Create/Shader/Default URP Shader")]
        public static void CreateDefaultURPShader()
        {
            ProjectWindowUtil.CreateScriptAssetFromTemplateFile(m_DefaultURPShaderTemplete, "DefaultURP.shader");
        }

        private const string m_DefaultHLSLTemplete = "Assets/SnowyOwl/Shaders/Templetes/DefaultHLSLTemplate.hlsl";
        [MenuItem("Assets/Create/Shader/Default HLSL")]
        public static void CreateDefaultHLSL()
        {
            ProjectWindowUtil.CreateScriptAssetFromTemplateFile(m_DefaultHLSLTemplete, "Default.hlsl");
        }
    }
}
