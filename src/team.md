# Simon Danisch - Author of Makie


```julia
# hide

GHProject(x) = DOM.a(splitdir(x)[end], href="https://github.com/$(x)")

projects = [
    GHProject("MakieOrg/Makie.jl"),
    GHProject("JuliaGPU/GPUArrays.jl"),
    GHProject("JuliaIO/FileIO.jl"),
    GHProject("SimonDanisch/JSServe.jl"),
    GHProject("JuliaLang/PackageCompiler.jl"),
    GHProject("JuliaGPU/CLArrays.jl"),
    GHProject("JuliaGeometry/GeometryBasics.jl"),
    GHProject("JuliaGraphics/FreeTypeAbstraction.jl"),
    GHProject("SimonDanisch/Matcha.jl"),
    GHProject("JuliaGeometry/Tetgen.jl"),
    GHProject("JuliaGeometry/EarCut.jl"),
    GHProject("JuliaGL/ModernGL.jl"),
]
FocusBlock(DOM.div(
    """
    I'm a Julia open source developer since 2012 and have helped build substantial parts of the graphics, GPU and plotting infrastructure in Julia.
    I'm  the author of: \n""",
    DOM.br(),
    projects);
    link="https://github.com/SimonDanisch",
    image="simon.jpg",
    rev=true
)
```

# Julius Krumbiegel - Co-Author

```julia
# hide

FocusBlock(
    """

    """;
    link="https://github.com/jkrumbiegel",
    image="julius.jpg"
)
```

# Frederic Freyer - GLMakie expert

```julia
# hide

coauthored = [
    GHProject("ffreyer/SphereSurfaceHistogram.jl"),
    GHProject("carstenbauer/BinningAnalysis.jl"),
    GHProject("carstenbauer/MonteCarlo.jl"),
    GHProject("ffreyer/LatPhysPlottingMakie.jl"),
]

contributions = [
    GHProject("MakieOrg/Makie.jl"),
    GHProject("fatteneder/MakieSlides.jl"),
    GHProject("JuliaPlots/MakieTeX.jl"),
    GHProject("JuliaIO/MeshIO.jl"),
    GHProject("JuliaGizmos/Observables.jl"),
    GHProject("JuliaGeometry/GeometryBasics.jl"),
]

FocusBlock(
    DOM.div(
    """
    I've started using Julia in 2018 to write a Monte-Carlo simulation for my Bachelor thesis in condensed matter physics. The project continued afterwards with code running on our HPC cluster, resulting in two papers. Since then I have continued working with Julia and contributed to various open source projects.

    Packages I (co-)authored include:
    """,
    DOM.br(),
    coauthored,
    DOM.br(),
    """
    And packages I contributed to mainly include the Makie ecosystem, especially Makie itself.
    """,
    DOM.br(),
    contributions,
    DOM.br(),
    """
    I am well experienced with the Makie ecosystem, including the internals of GLMakie, CairoMakie and Makie. I have contributed to many of the core components, such as for example the event system, rendering of meshes in CairoMakie or line rendering in GLMakie. From University I have experience in physics, teaching, HPC, performance optimization, linear algebra and float precision problems.
    """);
    image="frederic.jpg",
    rev=true
)
```


# Makie Contributors

```julia
# hide

FlexGrid(DOM.div.(owners, class="px-4 py-1")...)
```
