using System;
using System.Collections.Generic;

using UnityEngine;
using UnityEngine.Rendering.Universal;

namespace SnowyOwl.Rendering
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
        public LayerMask layerMask = 1;
        public RenderingLayerMask renderingLayerMask = 1;
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

    public static class GameCameraDefines
    {
        public enum Type
        {
            None = -1,

            MainCamera,     // Regular Base Camera, Scene Rendering
            RTCamera,       // Special Base Camera, separate from the CameraStack, RenderTarget is a Custom RT
            OverlayCamera,  // Regular Overlay Camera, such as Character close-up Camera
            UICamera,       // Special Overlay Camera, UI Rendering, it should be at the end of the CameraStack
        }

        private const string k_MainCamera = "MainCamera";
        private const string k_RTCamera = "RTCamera";
        private const string k_OverlayCamera = "OverlayCamera";
        private const string k_UICamera = "UICamera";

        public static readonly List<string> Tags = new() { k_MainCamera, k_RTCamera, k_OverlayCamera, k_UICamera };
    }

    // Core Utils Class
    public static class CustomRenderingUtils
    {
        public static GameCameraDefines.Type FetchGameCameraType(in CameraData cameraData)
        {
            return (GameCameraDefines.Type)GameCameraDefines.Tags.IndexOf(cameraData.camera.tag);
        }

        public static bool CheckGameCameraType(in CameraData cameraData, GameCameraDefines.Type cameraType, bool ifNonGameCamera = true)
        {
            // if camera is not a GameCamera
            if (!UniversalRenderPipeline.IsGameCamera(cameraData.camera))
            {
                return ifNonGameCamera;
            }

            return cameraType == FetchGameCameraType(cameraData);
        }
        public static bool CheckGameCameraTypes(in CameraData cameraData, List<GameCameraDefines.Type> cameraTypes, bool ifNonGameCamera = true)
        {
            // if camera is not a GameCamera
            if (!UniversalRenderPipeline.IsGameCamera(cameraData.camera))
            {
                return ifNonGameCamera;
            }

            foreach(var cameraType in cameraTypes)
            {
                if(cameraType == FetchGameCameraType(cameraData))
                    return true;
            }
            return false;
        }
    }
}
