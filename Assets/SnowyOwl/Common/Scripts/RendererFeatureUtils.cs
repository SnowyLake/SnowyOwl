using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Experimental.Rendering.Universal;
using UnityEngine.Rendering.Universal;

namespace Snowy.Owl
{
    [System.Serializable]
    public class RenderPassSettings
    {
        public FilterSettings filterSettings = new();

        [NonSerialized] public RenderPassEvent renderEvent;
        [NonSerialized] public RenderQueueType renderQueue;
        [NonSerialized] public List<string> renderPasses;
    }

    [System.Serializable]
    public class FilterSettings
    {
        public LayerMask layerMask;
        public RenderingLayerMask renderingLayerMask;

        public FilterSettings()
        {
            layerMask = 0;
            renderingLayerMask = RenderingLayerMask.LightLayerDefault;
        }
    }

    public enum RenderingLayerMask
    {
        LightLayerDefault,
        LightLayer1,
        LightLayer2,
        LightLayer3,
        LightLayer4,
        LightLayer5,
        LightLayer6,
        Outline
    }
}
