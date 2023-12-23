using System.Collections.Generic;

using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

namespace SnowyOwl.Rendering
{
    public class ToonOutlineRendererFeature : ScriptableRendererFeature
    {
        [System.Serializable]
        public class OutlinePassSettings : RenderPassSettings
        {
            public bool enableWriteDepth = true;
        }

        public OutlinePassSettings settings = new()
        {
            isOpaque = true,
            passEvent = RenderPassEvent.BeforeRenderingTransparents,
            passTags = new List<string> { "Outline" }
        };
        private ToonOutlinePass m_Pass;

        /// <inheritdoc/>
        public override void Create()
        {
            m_Pass = new ToonOutlinePass(settings);
        }

        public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData)
        {
            if (!CustomRenderingUtils.CheckCameraType(renderingData.cameraData.camera, settings.filterSettings.cameraTypes, true))
            {
                return;
            }
            renderer.EnqueuePass(m_Pass);
        }

        class ToonOutlinePass : ScriptableRenderPass
        {
            private class PassData
            {
                internal RenderingData renderingData; // Only used by RenderGraph
                internal ProfilingSampler profilingSampler;
                
                internal FilteringSettings filteringSettings;
                internal List<ShaderTagId> passTags;
                internal bool isOpaque;
            }
            private PassData m_PassData;

            public ToonOutlinePass(OutlinePassSettings settings)
            {
                this.renderPassEvent = settings.passEvent;

                m_PassData = new PassData
                {
                    profilingSampler = new ProfilingSampler("ToonOutlinePass"),
                    passTags = new List<ShaderTagId>(),
                    isOpaque = settings.isOpaque,
                };
                var renderQueueRange = m_PassData.isOpaque ? RenderQueueRange.opaque : RenderQueueRange.transparent;
                m_PassData.filteringSettings = new FilteringSettings(renderQueueRange, settings.filterSettings.layerMask, settings.filterSettings.renderingLayerMask);
                foreach (var tag in settings.passTags)
                {
                    m_PassData.passTags.Add(new ShaderTagId(tag));
                }
            }
            public override void OnCameraSetup(CommandBuffer cmd, ref RenderingData renderingData)
            {
            }

            private static void ExecutePass(ScriptableRenderContext context, PassData passData, ref RenderingData renderingData)
            {
                var cmd = renderingData.commandBuffer;

                using (new ProfilingScope(cmd, passData.profilingSampler))
                {
                    context.ExecuteCommandBuffer(cmd);
                    cmd.Clear();

                    SortingCriteria sortFlags = passData.isOpaque ? renderingData.cameraData.defaultOpaqueSortFlags : SortingCriteria.CommonTransparent;
                    DrawingSettings drawingSettings = RenderingUtils.CreateDrawingSettings(passData.passTags, ref renderingData, sortFlags);

                    context.DrawRenderers(renderingData.cullResults, ref drawingSettings, ref passData.filteringSettings);
                }
            }
            public override void Execute(ScriptableRenderContext context, ref RenderingData renderingData)
            {
                ExecutePass(context, m_PassData, ref renderingData);
            }

            public override void OnCameraCleanup(CommandBuffer cmd)
            {

            }
        }
    }
}
