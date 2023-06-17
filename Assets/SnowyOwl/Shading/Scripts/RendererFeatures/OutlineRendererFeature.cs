using System.Collections.Generic;
using UnityEngine.Experimental.Rendering.Universal;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

namespace Snowy.Owl.Shading
{
    public class OutlineRendererFeature : ScriptableRendererFeature
    {
        [System.Serializable]
        public class OutlinePassSettings : RenderPassSettings
        {
            public bool enableWriteDepth = true;
        }

        public OutlinePassSettings settings = new()
        {
            renderEvent = RenderPassEvent.BeforeRenderingTransparents,
            renderQueue = RenderQueueType.Opaque,
            renderPasses = new() { "Outline" }
        };
        private OutlinePass m_Pass;

        /// <inheritdoc/>
        public override void Create()
        {
            m_Pass = new(settings);
        }

        public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData)
        {
            renderer.EnqueuePass(m_Pass);
        }

        class OutlinePass : ScriptableRenderPass
        {
            private ProfilingSampler m_ProfilingSampler = new("OutlinePass");
            private OutlinePassSettings m_Settings;
            private FilteringSettings filteringSettings;
            private List<ShaderTagId> shaderTagIds = new();
            public OutlinePass(OutlinePassSettings settings)
            {
                m_Settings = settings;
                this.renderPassEvent = m_Settings.renderEvent;

                var renderQueue = m_Settings.renderQueue == RenderQueueType.Transparent ? RenderQueueRange.transparent : RenderQueueRange.opaque;
                this.filteringSettings = new FilteringSettings(renderQueue, m_Settings.filterSettings.layerMask, m_Settings.filterSettings.renderingLayerMask);

                foreach (var pass in m_Settings.renderPasses)
                {
                    shaderTagIds.Add(new ShaderTagId(pass));
                }
            }
            public override void OnCameraSetup(CommandBuffer cmd, ref RenderingData renderingData)
            {
            }

            public override void Execute(ScriptableRenderContext context, ref RenderingData renderingData)
            {
                var cmd = CommandBufferPool.Get();
                using (new ProfilingScope(cmd, m_ProfilingSampler))
                {
                    
                    SortingCriteria sortingCriteria = (m_Settings.renderQueue == RenderQueueType.Transparent) ? SortingCriteria.CommonTransparent : renderingData.cameraData.defaultOpaqueSortFlags;
                    DrawingSettings drawingSettings = CreateDrawingSettings(shaderTagIds, ref renderingData, sortingCriteria);

                    context.DrawRenderers(renderingData.cullResults, ref drawingSettings, ref filteringSettings);
                }

                context.ExecuteCommandBuffer(cmd);
                CommandBufferPool.Release(cmd);
            }

            public override void OnCameraCleanup(CommandBuffer cmd)
            {

            }
        }
    }
}