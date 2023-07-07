# SnowyOwl：Unity大世界&卡通渲染解决方案
这个项目只是我在工作之余用来自娱自乐、自我满足的一个途径, 故更新速度与兼容性无法保证.
我只是享受从事图形技术开发这件事本身.
当然, 既然是自我满足, 代码质量自然会在我自己的编码审美标准下尽可能做到最好.

## Feature/Todo List
- [ ] **Shading Library**
  - [ ] Toon
  - [ ] Other Features that URP dont have
- [ ] **Terrain System**
  - [ ] Rendering
    - [ ] Splatmap
    - [ ] Indexmap + Weightmap
    - [ ] Runtime Virtual Texture
  - [ ] GPU Driven Terrain/Grass
    - [ ] Culling by Hi-Z(Hierarchical Z-Buffer Visibility)
    - [ ] Culling by PVS(Potentially Visible Sets)
  - [ ] HLOD(Hierarchical Level of Detail)
- [ ] **SkyAtmosphere**
  - [ ] Physically Based Sky
  - [ ] Stylized Sky
  - [ ] Time Of Day
- [ ] **Global Illumination**
  - [ ] DDGI(Outdoor)
    - [ ] Irradiance Volume(Near, 256m * 256m * 256m)
    - [ ] Low Precision Lightmap(Far, Baked by Irradiance Volume)
  - [ ] PRTGI(Indoor)
  - [ ] SSGI(Extra)
  - [ ] HBAO / GTAO
- [ ] **PCG Pipeline**
- [ ] **There are also some features that require intrusive modify URP but so cool**