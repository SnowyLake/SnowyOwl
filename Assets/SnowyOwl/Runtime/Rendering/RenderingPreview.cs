using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

//namespace SnowyOwl.Rendering.Terrain { }
//namespace SnowyOwl.Rendering.SkyAtmosphere { }
//namespace SnowyOwl.Rendering.GlobalIllumination { }
//namespace SnowyOwl.PCG { }
//namespace SnowyOwl.PCG.Houdini { }
//namespace SnowyOwl.PCG.SubstanceDesigner { }

namespace SnowyOwl.Rendering.External
{
    [ExecuteInEditMode]
    public class RenderingPreview : MonoBehaviour
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
            //GUI.Button(new Rect(100, 100, 300, 150), "Button 0");
        }
    }

}