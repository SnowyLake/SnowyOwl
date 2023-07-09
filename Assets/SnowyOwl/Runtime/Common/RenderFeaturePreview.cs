using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

using Snowy.Owl;

[ExecuteInEditMode]
public class RenderFeaturePreview : MonoBehaviour
{
    void Start()
    {
        
    }

    void Update()
    {
        //SupportedRenderingFeatures.active.rendersUIOverlay = true;
    }

    private void OnGUI()
    {
        GUI.Button(new Rect(100, 100, 300, 150), "Button 0");
    }
}
