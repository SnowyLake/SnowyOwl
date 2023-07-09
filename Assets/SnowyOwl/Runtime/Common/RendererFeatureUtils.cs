using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.Universal;

namespace Snowy.Owl
{
    [Serializable]
    public class RenderPassSettings
    {
        public FilterSettings filterSettings = new();

        // Hardcode in Custom RendererFeature
        [NonSerialized] public bool isOpaque;
        [NonSerialized] public RenderPassEvent passEvent;
        [NonSerialized] public List<string> passTags;
    }

    [Serializable]
    public class FilterSettings
    {
        public LayerMask layerMask;
        public RenderingLayerMask renderingLayerMask;

        public FilterSettings()
        {
            layerMask = 1;
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

    public enum GameCameraType
    {
        None = -1,      // If Camera is not a GameCamera

        MainCamera,     // Regular Base Camera, Scene Rendering
        RTCamera,       // Special Base Camera, separate from the CameraStack, RenderTarget is a Custom RT
        OverlayCamera,  // Regular Overlay Camera, such as Character close-up Camera
        UICamera,       // Special Overlay Camera, UI Rendering, it should be at the end of the CameraStack

        Count
    }
    public static class RendererFeatureUtils
    {
        public static bool CheckGameCameraType(in CameraData cameraData, GameCameraType targetType, bool ifNonGameCamera = true)
        {
            var camera = cameraData.camera;

            // if camera is not a GameCamera
            if (!UniversalRenderPipeline.IsGameCamera(camera))
            {
                return ifNonGameCamera;
            }

            return camera.CompareTag(targetType.ToString());
        }
    }
}
