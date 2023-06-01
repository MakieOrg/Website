

```julia
# hide
overview_width = 150
[
    DOM.div(DOM.p("Makie is a modern plotting library for ", DOM.a("Julia", href="https://julialang.org"), " which is easy to use yet fast and powerful. It's packed with ", DOM.a("features", href="#Features"), " and the goal is to be not limited to any special use case, while making as few compromises as possible.
    "); class="w-96 text-xl m-1"),
    DetailedCard(
        title="Fast prototyping and data exploration",
        image="use_cases/clima-volume.gif",
        width=overview_width
    ),
    DetailedCard(
        title="Quickly publish your dashboards on the Web",
        image="use_cases/clima.gif",
        link="https://agupubs.onlinelibrary.wiley.com/doi/10.1029/2021MS002964",
        width=overview_width
    ),
    DetailedCard(
        title="Create publication ready SVGs/PDFs",
        image="use_cases/publication.png",
        link="https://iopscience.iop.org/article/10.3847/1538-3881/aca1af/pdf",
        width=overview_width
    ),
    DetailedCard(
        title="Stunning, foto realistic renderings",
        image="use_cases/earths_creditst.png",
        width=overview_width
    ),
    DetailedCard(
        title="Even video games are possible with Makie",
        image="use_cases/miner.gif",
        width=overview_width
    )
]
```

# Features

## Surgical updates & high performance
```julia
# hide
FocusBlock(
    """
    Makie updates only what's needed using Observables.jl.
    This example animates hundred thousand of points, by just updating the color, which only updates a few bytes per frame directly on the GPU.
    There's no faster way to animate large data, so Makie, together with utilizing the GPU and Julia's high performance, is fit for any task!
    """;
    image="use_cases/glacier.gif",
    link="https://makieorg.github.io/Tyler.jl/dev/examples/generated/UserGuide/iceloss_ex",
    rev=true
)
```
## Powerful Layouting

```julia
# hide
FocusBlock("""
    Makie has one of the most powerful layouting systems compared to other plotting
    libraries, allowing you to tweak any possible attribute and place your plots
    and subplots freely. No need to use inkscape anymore to redo your layout!""";
    image = "use_cases/layouting.png",
    link = "https://docs.makie.org/stable/tutorials/layout-tutorial/"
)
```
## 2D, 3D, Volumes, Meshes, Sliders, Buttons, etc

## Rich ecosystem

To cater to every use case, without becoming a big, bloated library, Makie is highly modular and extensible.
What Makie doesn't offer out of the box, gets supported by a rich 3rd party ecosystem:

```julia
# hide
eco_width = 150
[
    DetailedCard(
        title="GeoMakie.jl",
        link="https://github.com/MakieOrg/GeoMakie.jl",
        image="ecosystem/geomakie.png",
        width=eco_width,
        details="Geographical plotting utilities for Makie.jl",
    ),
    DetailedCard(
        title="Tyler.jl",
        link="https://github.com/MakieOrg/Tyler.jl",
        image="ecosystem/tyler-sam.gif",
        width=eco_width,
        details="Makie package to plot maptiles from various map providers"
    ),
    DetailedCard(
        title="FerriteViz.jl",
        link="https://github.com/Ferrite-FEM/FerriteViz.jl",
        image="ecosystem/ferrite-heartbeat.gif",
        width=eco_width,
        details=md"Small package to visualize [Ferrite.jl](https://github.com/Ferrite-FEM/Ferrite.jl) results, which is a simple finite element toolbox written in Julia."
    ),
    DetailedCard(
        title="GraphMakie.jl",
        link="https://github.com/MakieOrg/GraphMakie.jl",
        image="ecosystem/graphmakie.png",
        width=eco_width,
        details="Plotting graphs with Makie"
    ),
    DetailedCard(
        title="BioMakie.jl",
        link="https://github.com/kool7d/BioMakie.jl",
        image="ecosystem/biomakie.png",
        width=eco_width,
        details="User interface tools for bioinformatics"
    ),
    DetailedCard(
        title="TopoPlots.jl",
        link="https://github.com/MakieOrg/TopoPlots.jl",
        image="ecosystem/topoplots.png",
        width=eco_width,
        details="Makie topo plot recipes, for neuro-science, geo plots and anyone needing surface plots from unstructured data"
    ),
    DetailedCard(
        title="ModelingToolkitDesigner.jl",
        link="https://github.com/bradcarman/ModelingToolkitDesigner.jl",
        image="ecosystem/modelingtoolkitdesigner.gif",
        width=eco_width,
        details="A helper tool for visualizing and editing a ModelingToolkit.jl system connections"
    ),
    DetailedCard(
        title="PairPlots.jl",
        link="https://sefffal.github.io/PairPlots.jl/",
        image="ecosystem/pairplots.png",
        width=eco_width,
        details="Beautiful and flexible vizualizations of high dimensional data"
    ),
    DetailedCard(
        title="AlgebraOfGraphics.jl",
        link="https://aog.makie.org/",
        image="ecosystem/aog.png",
        width=eco_width,
        details="AlgebraOfGraphics defines a language for data visualization. It is based on a few simple building blocks that can be combined using + and *."
    ),
    DetailedCard(
        title="TidierPlots.jl",
        link="https://github.com/TidierOrg/TidierPlots.jl",
        image="ecosystem/tidier.png",
        width=eco_width,
        details="100% Julia implementation of the ggplot2 R package"
    ),
    DetailedCard(
        title="MeshViz.jl",
        link="https://github.com/JuliaGeometry/MeshViz.jl",
        image="ecosystem/meshviz.png",
        width=eco_width,
        details="Makie.jl recipes for visualization of Meshes.jl"
    ),

    DetailedCard(
        title="OSMMakie.jl",
        link="https://github.com/MakieOrg/OSMMakie.jl",
        image="ecosystem/osmmakie.png",
        width=eco_width,
        details="A Makie.jl recipe for plotting OpenStreetMap data."
    ),
    DetailedCard(
        title="GeneticsMakie.jl",
        image="ecosystem/geneticsmakie.png",
        link="https://github.com/mmkim1210/GeneticsMakie.jl",
        width=eco_width,
        details="🧬High-performance genetics-related data visualization using Makie.jl"
    ),
    DetailedCard(
        title="IncompressibleNavierStokes.jl",
        link="https://github.com/agdestein/IncompressibleNavierStokes.jl",
        image="ecosystem/incompressiblenavierstokes.gif",
        width=eco_width,
        details="Incompressible Navier-Stokes solver, utilizing Makie for interactive visualizations"
    ),
    DetailedCard(
        title="InteractiveViz.jl",
        link="https://github.com/org-arl/InteractiveViz.jl",
        image="ecosystem/interactiveviz.png",
        width=eco_width,
        details="Interactive visualization tools for Julia"
    ),
    DetailedCard(
        title="MakiePublications.jl",
        link="https://github.com/liuyxpp/MakiePublication.jl",
        image="ecosystem/makiepublications.svg",
        width=eco_width,
        details="A Julia package for producing publication quality figures based on Makie.jl."
    ),
    DetailedCard(
        title="UnfoldMakie.jl",
        link="https://github.com/unfoldtoolbox/UnfoldMakie.jl",
        image="ecosystem/unfoldmakie.png",
        width=eco_width,
        details="Plotting tools for Unfold.jl based on Makie.jl and AlgebraOfGraphics.jl"
    ),
    DetailedCard(
        title="NestedGraphMakie.jl",
        link="https://github.com/UniStuttgart-IKR/NestedGraphMakie.jl",
        image="ecosystem/nestedgraphmakie.png",
        width=eco_width,
        details="A package for NestedGraphs.jl to make easy visualizations."
    ),
    DetailedCard(
        title="MakieDraw.jl",
        link="https://github.com/MakieOrg/MakieDraw.jl",
        image="ecosystem/makiedraw.gif",
        width=eco_width,
        details="Plot an interactive canvas of GeometryBaseics Point, LineString or Polygon, or an ms-paint style canvas for any numerical or color Array"
    ),
    DetailedCard(
        title="Agents.jl",
        link="https://juliadynamics.github.io/Agents.jl/",
        image="ecosystem/agents.png",
        width=eco_width,
        details="Agents.jl is a pure Julia framework for agent-based modeling (ABM)"
    ),
]
```

## Backends


```julia
# hide

[
    DetailedCard(
        title="GLMakie",
        width=300,
        image="backends/glmakie.png",
        link="https://docs.makie.org/stable/documentation/backends/glmakie/",
        details=md"""* Super fast, interactive desktop applications
        * The first backend and the most feature complete
        * Uses the GPU via OpenGL for fast 3D animations
        * Basic UI elements for simple Dashboards
        * Needs a GPU, or a virtual GPU (e.g. Mesa, VirtualGL)
        """
    ),
        DetailedCard(
        title="CairoMakie",
        width=300,
        image="backends/cairomakie.svg",
        link="https://docs.makie.org/stable/documentation/backends/cairomakie/",
        details=md""" * Best 2D rendering quality
        * Can export SVGs, PDFs, etc
        * 3D support experimental
        * Not interactive
        * Runs everywhere on the CPU
        """
    ),
    DetailedCard(
        title="WGLMakie",
        width=300,
        image="backends/wglmakie.gif",
        link="https://docs.makie.org/stable/documentation/backends/wglmakie/",
        details=md"""* Creates visualizations via Threejs & WebGL in the browser
        * Has an overhead for transferring data to browser
        * Mostly feature complete, with some things still missing
        * Runs almost everywhere on the GPU
        * Great for working on remote machines, plotpane and notebooks
        """
    ),
    DetailedCard(
        title="RPRMakie",
        width=300,
        image="backends/rprmakie.png",
        link="https://docs.makie.org/stable/documentation/backends/rprmakie/",
        details=md"""* Newest, supports only a subset of Makie (mostly the 3d primitives)
        * Very slow, needs high end hardware for high quality animations
        * Still immature
        * looks amazing when it works"""
    ),
]
```

# Users

```julia
# hide

[
    Logo(image="clima-logo.png", link="https://clima.caltech.edu"),
    Logo(image="max-planck.png", link="https://www.bgc-jena.mpg.de/en/bgi/gallery"),
    Logo(image="nasa-jpl.svg", link="https://www.jpl.nasa.gov/"),
    Logo(image="microsoft.png", link="https://www.youtube.com/watch?v=7-vN8oNAz6Y"),
    Logo(image="instron.png", link="https://github.com/bradcarman/ModelingToolkitDesigner.jl"),
    Logo(image="dwd.png", link="https://www.youtube.com/watch?v=-Cg6AoymaM0")
]
```

# Supporters

```julia
# hide
[
    Logo(image="numfocus.png", link="https://numfocus.org/project/julia"),
    Logo(image="pumasai.svg", link="https://pumas.ai"),
    Logo(image="juliahub.svg", link="https://juliahub.com"),
    Logo(image="beacon.svg", link="https://beacon.bio"),
    Logo(image="mit.png", link=""),
    Logo(image="bmbf.svg", link=""),
]
```

# Support

## Sponsoring

## Voluntary License

## Support Contract

## Grant

## Consulting


# Follow us
```julia
# hide
[
    SmallLogo(image="twitter.svg", link="https://twitter.com/MakiePlots"),
    SmallLogo(image="linkedin.png", link="https://www.linkedin.com/company/makieorg"),
    SmallLogo(image="GitHub-Mark-64px.png", link="https://github.com/MakieOrg")]
```
