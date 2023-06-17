using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Experimental.Rendering.Universal;
using UnityEngine.Rendering.Universal;

namespace Snowy.Owl
{
    [Serializable]
    public class RenderPassSettings
    {
        public FilterSettings filterSettings = new();

        // Hard code in custom renderer feature
        [NonSerialized] public RenderPassEvent renderEvent;
        [NonSerialized] public RenderQueueType renderQueue;
        [NonSerialized] public List<string> renderPasses;
    }

    [Serializable]
    public class FilterSettings
    {
        public LayerMask layerMask;
        public RenderingLayerMask renderingLayerMask;

        public FilterSettings()
        {
            layerMask = 0;
            renderingLayerMask = 1;
        }
    }

    [Serializable]
    public struct RenderingLayerMask
    {
        public uint value;

        public static implicit operator uint(RenderingLayerMask mask)
        {
            return mask.value;
        }

        public static implicit operator RenderingLayerMask(uint intVal)
        {
            RenderingLayerMask result = default;
            result.value = intVal;
            return result;
        }
    }
}
