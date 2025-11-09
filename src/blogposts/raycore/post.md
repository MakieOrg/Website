# Announcing Raycore.jl: High-Performance Ray Tracing for CPU and GPU

I'm excited to announce [Raycore.jl](https://github.com/JuliaGeometry/Raycore.jl), a high-performance ray-triangle intersection engine with BVH acceleration, designed for both CPU and GPU execution in Julia. Whether you're building a physically-based renderer, simulating light transport, or exploring acoustic propagation, Raycore provides the performance and flexibility you need.

Raycore will power a new raytracing backend for Makie, bringing photorealistic rendering and advanced visualization capabilities to the Makie ecosystem. This opens up exciting possibilities for scientific visualization, architectural rendering, and more - all with the familiar Makie API.

## Why Write a New Ray Intersection Engine?

You might wonder: why build yet another ray tracer? The answer lies in Julia's unique strengths and the opportunities they create and the kind of flexibility we get to have complete control over the rendering in Makie.

### Advantages of Julia

* **High-level language with performance close to C/C++** - Write readable code that runs fast
* **Great GPU support** - Single codebase runs on CUDA, AMD, Metal, oneAPI, and OpenCL via KernelAbstractions.jl
* **Multiple dispatch for different geometries, algorithms, and materials** - Extend the system cleanly without modifying core code
* **Pluggable architecture for new features** - Add custom materials, sampling strategies, or acceleration structures
* **One of the best languages to write out math** - The code looks like the equations you'd write on paper

### Honest Assessment: The Tradeoffs

Julia isn't perfect, and there are certainly challenges:

* **Long compile times for first use** - The first run of a function triggers JIT compilation
* **GPU code still has some rough edges** - Complex kernels require careful attention to avoid allocations and GPU-unfriendly constructs

In practice, compile times aren't as bad as they might sound. You keep a Julia session running and only pay the compilation cost once. There's also ongoing work on precompilation that could reduce these times to near-zero in the future and compile most kernels ahead of time.
For GPU code, better tooling for detecting and fixing issues is on the horizon, along with improved error messages when problematic LLVM code is generated.

### The Big Picture

The flexibility to write a high-performance ray tracer in a high-level language opens up exciting possibilities:

* **Use automatic differentiation** to optimize scene parameters or light placement
* **Plug in new optimizations seamlessly** without fighting a type system or rewriting core algorithms
* **Democratize working on high-performance ray tracing** - contributions don't require C++ expertise and the code base is fairly small
* **Rapid experimentation** - test new ideas without lengthy compile cycles

## What is Raycore.jl?

Raycore is a focused library that does one thing well: fast ray-triangle intersections with BVH acceleration. It provides the building blocks for ray tracing applications without imposing a particular rendering architecture.

**Core Features:**
- Fast BVH construction and traversal
- CPU and GPU support via KernelAbstractions.jl
- Analysis tools: centroid calculation, illumination analysis, view factors for radiosity
- Makie integration for visualization

**Performance:** On GPU, we've achieved significant speedups through kernel optimizations including loop unrolling, tiling, and wavefront rendering approaches that minimize thread divergence.

## Interactive Tutorials

The documentation includes several hands-on tutorials that build from basics to advanced GPU optimization:

### 1. BVH Hit Tests & Basics

Learn the fundamentals of ray-triangle intersection, BVH construction, and visualization.

![BVH Basics](./images/basics.png)

[Try the tutorial →](https://juliageometry.github.io/Raycore.jl/dev/)

### 2. Ray Tracing Tutorial

Build a complete ray tracer from scratch with shadows, materials, reflections, and tone mapping.

![Ray Tracing](./images/raytracing.png)

[Try the tutorial →](https://juliageometry.github.io/Raycore.jl/dev/)

### 3. Ray Tracing on the GPU

Port the ray tracer to GPU and learn optimization techniques: loop unrolling, tiling, and wavefront rendering. Includes comprehensive benchmarks comparing different approaches.

![GPU Benchmarks](./images/gpu-benchmarks.png)

[Try the tutorial →](https://juliageometry.github.io/Raycore.jl/dev/)

### 4. View Factors & Analysis

Calculate view factors, illumination, and centroids for radiosity and thermal analysis applications.

![View Factors](./images/viewfactors.png)

[Try the tutorial →](https://juliageometry.github.io/Raycore.jl/dev/)

## What Can It Be Used For?

Ray tracing isn't just for rendering pretty pictures. Raycore enables a wide range of physics and engineering applications:

* **Physically-based rendering** - Photorealistic image synthesis with accurate light transport
* **Light transport simulations** - Analyze lighting design, daylighting, and energy efficiency
* **Acoustic simulations** - Model sound propagation in architectural spaces
* **Neutron transport simulations** - Nuclear reactor analysis and radiation shielding
* **Thermal radiosity** - Heat transfer analysis in complex geometries
* **Scientific visualization with Makie** - The upcoming raytracing backend will enable photorealistic rendering of scientific data
* **Any application that needs ray tracing** - The core is general-purpose

A high-performance implementation of CPU and GPU ray tracing in Julia can be a huge enabler for research and development in these fields, especially considering how easy it is to jump into the code and make changes dynamically. Need to add a new material model? Write a few methods. Want to try a different BVH construction algorithm? Implement the interface. The barrier to experimentation is low.

## Getting Started

Install Raycore.jl from the Julia package manager:

```julia
using Pkg
Pkg.add("Raycore")
```

Then check out the [interactive tutorials](https://juliageometry.github.io/Raycore.jl/dev/) to start building your first ray tracer!

## Future Work

While Raycore is ready for many applications, there are exciting directions for future development:

* **Makie raytracing backend** - Bringing photorealistic rendering to the Makie ecosystem
* **Advanced acceleration structures** - Explore alternatives to BVH like kd-trees or octrees for specific use cases
* **GPU memory optimizations** - Reduce memory footprint for larger scenes
* **Improved precompilation** - Further reduce first-run latency
* **Further optimize performance** - It would be great to have as many people as possible work on optimizing this to the core :)

Contributions are welcome! The codebase is designed to be approachable, and the Julia community is friendly and helpful.

## Acknowledgments

Raycore.jl was split out from [Trace.jl](https://github.com/JuliaGraphics/Trace.jl), originally created by [Anton Smirnov](https://github.com/pxl-th). Trace.jl will soon be renamed to **Hikari** and released as the main ray tracing implementation built on top of Raycore, providing a complete path tracing framework.

This project builds on the excellent work of the Julia GPU ecosystem, particularly KernelAbstractions.jl for portable GPU programming, and the Julia visualization stack including Makie.jl for the interactive tutorials.

Special thanks to everyone who provided feedback during development and helped shape Raycore into what it is today.

I'm excited to see what you build with Raycore.jl. Happy ray tracing!
