# Ray Tracing in Makie: From Research Data to Photorealistic Renders

We're excited to announce **TraceMakie** and **Hikari** — a physically-based GPU ray tracing pipeline integrated directly into [Makie](https://docs.makie.org).
Any Makie scene can now be rendered with photorealistic path tracing: just swap `colorbuffer` parameters and get global illumination, volumetric media, spectral rendering, and physically-based materials — all running on the GPU.

![Terrain with volumetric clouds over the Austrian Alps](./images/terrain.png)

## Why Ray Tracing in Julia?

Research groups across many fields — climate science, structural biology, fluid dynamics, particle physics — produce complex 3D data that needs to be communicated clearly and compellingly.
Photorealistic rendering can transform dense simulation output into images that reveal structure and tell a story. But getting research data into a traditional ray tracer usually means exporting meshes, learning new tools, and losing the interactive workflow.

By building ray tracing directly into Makie, we eliminate that gap. The same scene you explore interactively with GLMakie can be rendered photorealistically with TraceMakie — no export step, no new API to learn.

Writing the implementation in Julia gives us:

- **Performance** — Julia compiles to efficient GPU code, competitive with C++ ray tracers
- **Cross-vendor GPU support** — A single codebase runs on AMD, NVIDIA, and CPU via [KernelAbstractions.jl](https://github.com/JuliaGPU/KernelAbstractions.jl)
- **Makie integration** — The familiar Makie API for scene construction, camera control, and lighting, with ray tracing as a drop-in rendering option
- **Modular architecture** — Custom materials, media, and integrators run directly on the GPU through Julia's multiple dispatch, opening up novel visualization and simulation use cases
- **Hackability** — A state-of-the-art spectral path tracer in a high-level language makes ray tracing research and experimentation accessible to a much wider audience

## How It Works

Hikari is a Julia port of [pbrt-v4](https://pbrt.org/), the reference implementation from *Physically Based Rendering* (Pharr, Jakob, Humphreys). It implements a wavefront volumetric path tracer with spectral rendering, supporting participating media (NanoVDB, grid-based volumes), physically-based materials (metals, dielectrics, coated surfaces), and environment/sun-sky lighting.

TraceMakie connects Hikari to Makie's scene graph. You build a scene with standard Makie calls — `mesh!`, `surface!`, `volume!`, `meshscatter!` — set materials and lights, then render:

```julia
# no-eval
using TraceMakie, Hikari

scene = Scene(size=(1920, 1080), lights=[SunSkyLight(Vec3f(1, 2, 8))])
cam3d!(scene)
mesh!(scene, my_mesh; material=Hikari.Gold(roughness=0.1))

img = colorbuffer(scene;
    device=AMDGPU.ROCBackend(),  # or CUDABackend(), CPU()
    integrator=Hikari.VolPath(samples=100, max_depth=12),
    sensor=Hikari.FilmSensor(iso=100, white_balance=6500),
)
```

## Showcases

### Oceananigans — Volumetric Cloud Rendering

[Oceananigans.jl](https://github.com/CliMA/Oceananigans.jl) is a GPU-accelerated ocean and atmosphere simulator developed at MIT's Climate Modeling Alliance (CliMA).
The Breeze demo renders Large Eddy Simulation (LES) cloud data as photorealistic volumetric clouds, using NanoVDB sparse grids for efficient storage and Hikari's volumetric path tracing for physically-accurate light scattering through the cloud medium.

![BOMEX cumulus clouds rendered with volumetric path tracing](./images/breeze.png)

The terrain demo combines real elevation data from OpenStreetMap (via [Tyler.jl](https://github.com/MakieOrg/Tyler.jl)) with BOMEX cloud volumes, inspired by [rayshader](https://www.rayshader.com/).

![Alpine terrain with volumetric clouds](./images/terrain.png)

> Makie-Oceananigans integration has been a major initiative over the past year. The ray tracing work with Breeze is truly groundbreaking in my opinion. It may be crucial for science, for inspecting the structure of clouds and thunderstorms. It also has the potential to lead to commercial products.
>
> — **Gregory Wagner**, Research Scientist at MIT and CliMA (Climate Modeling Alliance), lead developer of Oceananigans.jl and Breeze.jl

### PlantGeom — Digital Twins for Agriculture

[PlantGeom.jl](https://github.com/VEZY/PlantGeom.jl) renders biophysically accurate 3D plant models for agricultural research.
The ray-traced oil palm uses coated diffuse transmission materials to simulate the waxy leaf cuticle and subsurface light transport through leaf tissue.

![Ray-traced oil palm with translucent leaves](./images/plants.png)

> Makie has become a central part of my daily scientific workflow. The fact that a single plotting ecosystem can cover the entire spectrum from high-performance 3D scenes to publication-ready figures is just exceptional. Several of the packages I develop would simply not exist in their current form without Makie. My research focuses on developing plant-scale digital twins to study complex agricultural systems (agroforestry, species mixtures, agrivoltaics) with the goal of understanding crop responses to climate and contributing to food security and climate-change adaptation. The recent work on ray tracing is especially exciting: beyond rendering, I am planning to use RayCore.jl for scientific applications such as computing radiation interception in plant canopies, which enables organ-scale energy balance calculations (latent and sensible heat fluxes) and photosynthesis modeling. Understanding how plant shadows affect heat transfer is crucial for adapting agriculture to extreme heat events. Makie has been a genuine force multiplier for my research.
>
> — **Remi Vezy**, CIRAD, developer of PlantGeom.jl

### ProtPlot — Protein Structure Visualization

[ProtPlot.jl](https://github.com/MurrellGroup/ProtPlot.jl) renders protein ribbon diagrams with physically-based materials.
Gold metallic rendering reveals the 3D structure of protein folds in a way that flat shading cannot — the specular highlights and ambient occlusion make spatial relationships immediately clear.

Different materials reveal different aspects of the structure — glass refractions show the interior ribbon path, while a coated diffuse surface emphasizes the overall shape and secondary structure:

![Protein ribbon with coated diffuse material](./images/protplot_7pkz.png)

![Protein ribbon with glass material](./images/protplot_glass.png)

ProtPlot also powers animated visualizations of protein folding trajectories — the transport process that generative models learn to perform. Ray tracing makes the spatial relationships in these animations immediately legible. The code to produce this is almost entirely standard Makie and ProtPlot — only the imports and a few rendering parameters change:

```julia
# no-eval
using TraceMakie, ProtPlot, Hikari, AMDGPU

device = AMDGPU.ROCBackend()

tracks = readdir("Trajectories/samp_00015", join=true)
set_theme!(lights=[
    Makie.SunSkyLight(Vec3f(0.4, -0.3, 0.7);
        intensity=1.0f0, turbidity=3.0f0, ground_enabled=false),
])
ProtPlot.animate_molecule_dir("trajectory.mp4", tracks)
```

The `animate_molecule_dir` function is pure ProtPlot code — it builds Makie figures with `Axis3`, `atomplot!`, and `ribbon!` as usual. TraceMakie intercepts the `record` call and path-traces each frame automatically.

![Protein folding trajectory](./images/protplot_trajectory.mp4)

> My lab is working on new kinds of generative models, primarily for protein structures. These work by specifying a process that transports randomly sampled noise to a biophysically plausible protein structure, and training a deep neural network to learn how to do this. But the details of this transport process are critical and, while you can to some extent mathematically reason about it, there is no substitute to being able to actually see it in action, both when you're designing it and when investigating how well the model has actually learned it. We rely entirely on Makie for this. These are not just for our internal use, but can be valuable for communicating how the methods work. Developments like raytracing will allow us to configure these to show exactly the details we seek to communicate without them getting buried in the complexity.
>
> — **Ben Murrell**, Karolinska Institutet, developer of ProtPlot.jl

### TrixiParticles — Fluid Simulation

[TrixiParticles.jl](https://github.com/trixi-framework/TrixiParticles.jl) simulates fluid dynamics with smoothed particle hydrodynamics.
The water splash demo renders SPH surface meshes with glass materials (IOR 1.33) — Fresnel reflections and refractions create the characteristic look of water without any post-processing. The animation shows a gold ball dropping into water, with each frame independently path-traced:

![Water splash animation](./images/trixi_water.mp4)

> Native raytracing in Makie would let us move some of our workflows entirely into Julia, from simulation to publication-ready figures, without relying on external tools.
>
> — **Dr. Michael Schlottke-Lakemper**, University of Stuttgart, lead developer of TrixiParticles.jl

### Volumetric Rendering — Clouds, Smoke, and Exhaust Plumes

Participating media are first-class citizens in Hikari's path tracer. Light scatters through volumes realistically — no billboard tricks or screen-space approximations. Hikari supports two volume representations: **NanoVDB** sparse grids for large-scale data (like the cloud simulations above), and **RGBGridMedium** for dense grids with per-voxel color, emission, and scattering properties. Both integrate directly with Makie's `volume!` plot or can be attached to any mesh as a `MediumInterface`.

The **Stanford bunny cloud** from the [pbrt-v4 test scenes](https://github.com/mmp/pbrt-v4-scenes), rendered with NanoVDB and Henyey-Greenstein phase function scattering:

![Stanford bunny cloud](./images/bunny.png)

A **sphere wake** from [WaterLily.jl](https://github.com/WaterLily-jl/WaterLily.jl) LES simulation, visualized as volumetric smoke. The volume density is updated in-place each frame via `RGBGridMedium` with a colormap, so the scene never needs to be rebuilt:

![WaterLily smoke animation](./images/waterlily.mp4)

The **HL-20 spacecraft** with a procedurally generated emissive rocket exhaust plume — `RGBGridMedium` with per-voxel emission creates the blue-white core fading to orange at the edges:

![HL-20 spacecraft with volumetric exhaust](./images/spacecraft.png)

### GLTF Models — Emissive Textures and Scene Composition

TraceMakie loads GLTF/GLB models and automatically maps their PBR materials to Hikari equivalents. Emissive texture maps create area lights that both glow and illuminate the scene — the Christmas tree decorations below are lit entirely by their own emissive maps:

![Christmas tree with glowing decorations and drone](./images/drone_christmas.png)

### Black Hole — Custom GPU Materials

One of the most powerful aspects of building a ray tracer in Julia is that users can define entirely new physics by subtyping `Hikari.Medium`. The black hole demo demonstrates this: a custom `SpacetimeMedium` struct implements gravitational lensing by overriding `Hikari.apply_deflection` to bend light rays according to the Schwarzschild metric. The accretion disk is an emissive volumetric density field with temperature-dependent coloring — hotter near the event horizon, cooler at the outer edge.

Because Julia's multiple dispatch compiles these custom methods directly into the GPU kernels alongside the built-in materials, there is no performance penalty for user-defined physics. The same wavefront path tracer handles standard glass and metals alongside relativistic spacetime curvature.

![Black hole with accretion disk and gravitational lensing](./images/blackhole.png)

## Getting Started

TraceMakie is available as a Makie backend. To render any existing Makie scene with ray tracing:

```julia
# no-eval
using TraceMakie, Hikari

# Build your scene with standard Makie
scene = Scene(size=(800, 600), lights=[SunSkyLight(Vec3f(1, 2, 8))])
cam3d!(scene)
mesh!(scene, my_geometry; material=Hikari.Gold())

# Render with path tracing
img = colorbuffer(scene;
    device=AMDGPU.ROCBackend(),
    integrator=Hikari.VolPath(samples=100, max_depth=12),
)
```

For interactive exploration, use `TraceMakie.interactive_window` to progressively refine the image while adjusting the camera in real time.

## Acknowledgments

Hikari is a Julia port of [pbrt-v4](https://pbrt.org/) by Matt Pharr, Wenzel Jakob, and Greg Humphreys.
It builds on [Trace.jl](https://github.com/JuliaGraphics/Trace.jl), originally created by [Anton Smirnov](https://github.com/pxl-th), and on the [Raycore.jl](https://github.com/JuliaGeometry/Raycore.jl) intersection engine.
GPU support is powered by [KernelAbstractions.jl](https://github.com/JuliaGPU/KernelAbstractions.jl) and the Julia GPU ecosystem.

Parts of this work was made possible by an investment of the [Sovereign Tech Agency](https://www.sovereign.tech) and most of the optimization and GPU work has been funded by [Muon Space](https://www.muonspace.com/).
