using System;
using System.Collections.Generic;
using System.Linq;
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
        public List<GameCameraDefine.Type> cameraTypes = new() { GameCameraDefine.Type.MainCamera };
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

    public static class GameCameraDefine
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
        public static bool IsGameCamera(Camera camera)
        {
            return camera.cameraType == CameraType.Game;
        }
        public static bool IsSceneViewCamera(Camera camera)
        {
            return camera.cameraType == CameraType.SceneView;
        }
            
        public static GameCameraDefine.Type FetchCameraType(Camera camera)
        {
            return (GameCameraDefine.Type)GameCameraDefine.Tags.IndexOf(camera.tag);
        }

        public static bool CheckCameraType(Camera camera, GameCameraDefine.Type cameraType, bool ifSceneViewCamera = true)
        {
            return (camera.enabled && IsGameCamera(camera) && FetchCameraType(camera) == cameraType) 
                   || IsSceneViewCamera(camera) && ifSceneViewCamera;
        }
        public static bool CheckCameraType(Camera camera, List<GameCameraDefine.Type> cameraTypes, bool ifSceneViewCamera = true)
        {
            if (IsSceneViewCamera(camera) && ifSceneViewCamera)
            {
                return true;
            }

            if (cameraTypes.Any(cameraType => FetchCameraType(camera) == cameraType))
            {
                return camera.enabled && IsGameCamera(camera);
            }
            
            return false;
        }
    }
}
