using UnityEditor;
using UnityEngine;
using UnityEngine.Rendering.Universal;

namespace SnowyOwl.Rendering
{
    [CustomPropertyDrawer(typeof(RenderingLayerMask))]
    public class RenderingLayerMaskEditor : PropertyDrawer
    {
        public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
        {
            var mask = property.FindPropertyRelative("value");
            int renderingLayer = mask.intValue;

            string[] renderingLayerMaskNames = UniversalRenderPipelineGlobalSettings.instance.renderingLayerMaskNames;
            int maskCount = (int)Mathf.Log(renderingLayer, 2) + 1;
            
            if (renderingLayerMaskNames.Length < maskCount && maskCount <= 32)
            {
                var newRenderingLayerMaskNames = new string[maskCount];
                for (int i = 0; i < maskCount; ++i)
                {
                    newRenderingLayerMaskNames[i] = i < renderingLayerMaskNames.Length ? renderingLayerMaskNames[i] : $"Layer{i}_Unused";
                }
                renderingLayerMaskNames = newRenderingLayerMaskNames;

                EditorGUILayout.HelpBox($"One or more of the Rendering Layers is not defined in the Universal Global Settings asset.", MessageType.Warning);
            }

            EditorGUI.BeginProperty(position, label, property);

            EditorGUI.BeginChangeCheck();
            renderingLayer = EditorGUI.MaskField(position, label, renderingLayer, renderingLayerMaskNames);

            if (EditorGUI.EndChangeCheck())
                mask.uintValue = (uint)renderingLayer;

            EditorGUI.EndProperty();
        }
    }
}

