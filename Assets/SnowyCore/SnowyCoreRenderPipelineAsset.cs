using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

[CreateAssetMenu(menuName = "Rendering/SnowyCoreRenderPipeline")]
public class SnowyCoreRenderPipelineAsset : RenderPipelineAsset
{
    public Cubemap m_DiffuseIBL;
    public Cubemap m_SpecularIBL;
    public Texture m_BRDFLut;
    protected override RenderPipeline CreatePipeline()
    {
        var rp = new SnowyCoreRenderPipeline
        {
            DiffuseIBL = m_DiffuseIBL,
            SpecularIBL = m_SpecularIBL,
            BRDFLut = m_BRDFLut
        };
        return rp;
    }
}
