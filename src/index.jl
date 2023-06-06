
using JSServe: @dom_str

semibold(text) = DOM.span(text, class="font-semibold")

function index_page(s)
    overview_width = 150
    eco_width = 150
    Julia = link("Julia", "https://julialang.org")

    be_quote = link(DOM.img(src=img_asset("benedikt-tweet.png"); class=CARD_STYLE), "https://twitter.com/BenediktEhinger/status/1665326068973158400")
    return DOM.div(
        Section(
            FlexGrid(
                TextBlock(width="w-96 pl-2 pb-2 ",
                    dom"""
                    $(semibold("Makie")) is a modern plotting library for $Julia,
                    which is easy to use yet fast and powerful. It's packed with features,
                    and the goal is to be not limited to any special use case, while making as few compromises as possible.
                    """),
                Showcase(
                    title="Explore billions of data points",
                    image="use_cases/datashader.mp4",
                    href=""
                ),
                Showcase(
                    title="Publication ready SVGs",
                    image="use_cases/publication.jpg",
                    href="https://agupubs.onlinelibrary.wiley.com/doi/10.1029/2022MS003527",
                ),
                Showcase(
                    title="Photorealistic renderings",
                    image="backends/rprmakie.png",
                    href="https://www.bgc-jena.mpg.de/en/bgi/gallery",
                ),
                Showcase(
                    title="Dashboards on the Web",
                    image="use_cases/clima.gif",
                    href="https://simondanisch.github.io/JSServe.jl",
                ),
                Showcase(
                    title="Video games",
                    image="use_cases/miner.png",
                    href="https://github.com/ashwani-rathee/Miner.jl"
                )
            )
        ),

        Section(bg="bg-gray-100",
            H1("Features"),

            H2("Surgical updates & high performance"),

            FocusBlock(
                """
                Makie updates only what's needed using Observables.jl.
                This example animates hundred thousand of points, by just updating the color, which only updates a few bytes per frame directly on the GPU.
                There's no faster way to animate large data, so Makie, together with utilizing the GPU and Julia's high performance, is fit for any task!
                """;
                image="use_cases/glacier.gif",
                link="https://makieorg.github.io/Tyler.jl/dev/examples/generated/UserGuide/iceloss_ex",
                rev=true
            ),
            H2("Powerful Layouting"),
            FocusBlock(dom"""
                Makie has one of the most powerful layouting systems compared to other plotting
                libraries, allowing you to tweak any possible attribute and place your plots
                and subplots freely.
                """;
                image=DOM.div(be_quote, render_media(img_asset("use_cases/layouting.png"); class=CARD_STYLE)),
                link = "https://docs.makie.org/stable/tutorials/layout-tutorial/"
            ),

            H2("2D, 3D, Volumes, Meshes, Sliders, Buttons and more"),
            FocusBlock("""
                Makie has support for all kind of primitives for interactive data exploration. This makes it simple, to quickly build up dashboards for any kind of data.
                """,
                image="use_cases/clima-volume.gif",
                rev=true
            ),

            H2("Backends"),
            TextBlock("""Makie's backends are the reason, why we can have high quality vector graphics for publication, while also delivering fast GPU accelerated renderings.
            Use exactly the same code, and change how your interactive graphic is displayed simply by switching the backend.
            """),
            FlexGrid(
                DetailedCard(
                    title="GLMakie",
                    width=400,
                    image="backends/glmakie.png",
                    link="https://docs.makie.org/stable/documentation/backends/glmakie/",
                    details=md"""* Super fast, interactive desktop applications
                    * The first backend and the most feature complete
                    * Uses the GPU via OpenGL for fast 3D animations
                    * Basic UI elements for simple Dashboards
                    * Needs a GPU, or a virtual GPU (e.g. Mesa, VirtualGL)
                    * Image from: $(link("A. N. Souza", "https://agupubs.onlinelibrary.wiley.com/doi/10.1029/2022MS003527"))
                    """
                ),
                    DetailedCard(
                    title="CairoMakie",
                    width=400,
                    image="backends/cairomakie.svg",
                    link="https://docs.makie.org/stable/documentation/backends/cairomakie/",
                    details=md""" * Best 2D rendering quality
                    * Can export SVGs, PDFs, etc
                    * 3D support experimental
                    * Not interactive
                    * Runs everywhere on the CPU
                    * Image from: $(link("beautiful.makie.org", "https://beautiful.makie.org"))
                    """
                ),
                DetailedCard(
                    title="WGLMakie",
                    width=400,
                    image="backends/wglmakie.gif",
                    link="https://docs.makie.org/stable/documentation/backends/wglmakie/",
                    details=md"""* Creates visualizations via Threejs & WebGL in the browser
                    * Has an overhead for transferring data to browser
                    * Mostly feature complete, with some things still missing
                    * Runs almost everywhere on the GPU
                    * Great for working on remote machines, plotpane and notebooks
                    * Image from: $(link("VISUS", "https://www.visus.uni-stuttgart.de"))
                    """
                ),
                DetailedCard(
                    title="RPRMakie",
                    width=400,
                    image="use_cases/earths_creditst.png",
                    link="https://docs.makie.org/stable/documentation/backends/rprmakie/",
                    details=md"""* Newest, supports only a subset of Makie (mostly the 3d primitives)
                    * Very slow, needs high end hardware for high quality animations
                    * Still immature
                    * looks amazing when it works
                    * Image from: $(link("Lazaro Alonso", "https://github.com/lazarusA"))
                    """
                ),
            ),
        ),
        Section(
            H1("Rich Ecosystem"),
            DOM.div("""
            To cater to every use case, without becoming a big, bloated library, Makie is highly modular and extensible.
            What Makie doesn't offer out of the box, gets supported by a rich 3rd party ecosystem:
            """; class="text-xl"),

            FlexGrid(
                DetailedCard(
                    title="GeoMakie.jl",
                    link="https://github.com/MakieOrg/GeoMakie.jl",
                    image="ecosystem/geomakie.png",
                    height=eco_width,
                    details="Geographical plotting utilities for Makie.jl",
                ),
                DetailedCard(
                    title="Tyler.jl",
                    link="https://github.com/MakieOrg/Tyler.jl",
                    image="ecosystem/tyler-sam.gif",
                    height=eco_width,
                    details="Makie package to plot maptiles from various map providers"
                ),
                DetailedCard(
                    title="FerriteViz.jl",
                    link="https://github.com/Ferrite-FEM/FerriteViz.jl",
                    image="ecosystem/ferrite.gif",
                    height=eco_width,
                    details=md"Small package to visualize [Ferrite.jl](https://github.com/Ferrite-FEM/Ferrite.jl) results, which is a simple finite element toolbox written in Julia."
                ),
                DetailedCard(
                    title="GraphMakie.jl",
                    link="https://github.com/MakieOrg/GraphMakie.jl",
                    image="ecosystem/graphmakie.png",
                    height=eco_width,
                    details="Plotting graphs with Makie"
                ),
                DetailedCard(
                    title="BioMakie.jl",
                    link="https://github.com/kool7d/BioMakie.jl",
                    image="ecosystem/biomakie.png",
                    height=eco_width,
                    details="User interface tools for bioinformatics"
                ),
                DetailedCard(
                    title="TopoPlots.jl",
                    link="https://github.com/MakieOrg/TopoPlots.jl",
                    image="ecosystem/topoplots.png",
                    height=eco_width,
                    details="Makie topo plot recipes, for neuro-science, geo plots and anyone needing surface plots from unstructured data"
                ),
                DetailedCard(
                    title="ModelingToolkitDesigner.jl",
                    link="https://github.com/bradcarman/ModelingToolkitDesigner.jl",
                    image="ecosystem/modelingtoolkitdesigner.gif",
                    height=eco_width,
                    details="A helper tool for visualizing and editing a ModelingToolkit.jl system connections"
                ),
                DetailedCard(
                    title="PairPlots.jl",
                    link="https://sefffal.github.io/PairPlots.jl/",
                    image="ecosystem/pairplots.png",
                    height=eco_width,
                    details="Beautiful and flexible vizualizations of high dimensional data"
                ),
                DetailedCard(
                    title="AlgebraOfGraphics.jl",
                    link="https://aog.makie.org/",
                    image="ecosystem/aog.png",
                    height=eco_width,
                    details="AlgebraOfGraphics defines a language for data visualization. It is based on a few simple building blocks that can be combined using + and *."
                ),
                DetailedCard(
                    title="TidierPlots.jl",
                    link="https://github.com/TidierOrg/TidierPlots.jl",
                    image="ecosystem/tidier.png",
                    height=eco_width,
                    details="100% Julia implementation of the ggplot2 R package"
                ),
                DetailedCard(
                    title="MeshViz.jl",
                    link="https://github.com/JuliaGeometry/MeshViz.jl",
                    image="ecosystem/meshviz.png",
                    height=eco_width,
                    details="Makie.jl recipes for visualization of Meshes.jl"
                ),

                DetailedCard(
                    title="OSMMakie.jl",
                    link="https://github.com/MakieOrg/OSMMakie.jl",
                    image="ecosystem/osmmakie.png",
                    height=eco_width,
                    details="A Makie.jl recipe for plotting OpenStreetMap data."
                ),
                DetailedCard(
                    title="GeneticsMakie.jl",
                    image="ecosystem/geneticsmakie.png",
                    link="https://github.com/mmkim1210/GeneticsMakie.jl",
                    height=eco_width,
                    details="🧬High-performance genetics-related data visualization using Makie.jl"
                ),
                DetailedCard(
                    title="IncompressibleNavierStokes.jl",
                    link="https://github.com/agdestein/IncompressibleNavierStokes.jl",
                    image="ecosystem/incompressiblenavierstokes.gif",
                    height=eco_width,
                    details="Incompressible Navier-Stokes solver, utilizing Makie for interactive visualizations"
                ),
                DetailedCard(
                    title="InteractiveViz.jl",
                    link="https://github.com/org-arl/InteractiveViz.jl",
                    image="ecosystem/interactiveviz.png",
                    height=eco_width,
                    details="Interactive visualization tools for Julia"
                ),
                DetailedCard(
                    title="MakiePublications.jl",
                    link="https://github.com/liuyxpp/MakiePublication.jl",
                    image="ecosystem/makiepublications.svg",
                    height=eco_width,
                    details="A Julia package for producing publication quality figures based on Makie.jl."
                ),
                DetailedCard(
                    title="UnfoldMakie.jl",
                    link="https://github.com/unfoldtoolbox/UnfoldMakie.jl",
                    image="ecosystem/unfoldmakie.png",
                    height=eco_width,
                    details="Plotting tools for Unfold.jl based on Makie.jl and AlgebraOfGraphics.jl"
                ),
                DetailedCard(
                    title="NestedGraphMakie.jl",
                    link="https://github.com/UniStuttgart-IKR/NestedGraphMakie.jl",
                    image="ecosystem/nestedgraphmakie.png",
                    height=eco_width,
                    details="A package for NestedGraphs.jl to make easy visualizations."
                ),
                DetailedCard(
                    title="MakieDraw.jl",
                    link="https://github.com/MakieOrg/MakieDraw.jl",
                    image="ecosystem/makiedraw.gif",
                    height=eco_width,
                    details="Plot an interactive canvas of GeometryBaseics Point, LineString or Polygon, or an ms-paint style canvas for any numerical or color Array"
                ),
                DetailedCard(
                    title="Agents.jl",
                    link="https://juliadynamics.github.io/Agents.jl/",
                    image="ecosystem/agents.png",
                    height=eco_width,
                    details="Agents.jl is a pure Julia framework for agent-based modeling (ABM)"
                ),
            ),
        ),
        Section(bg="white",
            DOM.div("Users"; class="text-xl text-black flex justify-center mt-14 mb-10 font-semibold"),
            FlexGrid(
                Logo(image="logos/climaalliancelogo.png", link="https://clima.caltech.edu"),
                Logo(image="logos/mpg_biogeochemistry.png", link="https://www.bgc-jena.mpg.de/en/bgi/gallery"),
                Logo(image="logos/nasa_jpl.png", link="https://www.jpl.nasa.gov/"),
                Logo(image="logos/microsoft.png", link="https://www.youtube.com/watch?v=7-vN8oNAz6Y"),
                Logo(image="logos/instron.png", link="https://github.com/bradcarman/ModelingToolkitDesigner.jl"),
                Logo(image="logos/dwd.png", link="https://www.youtube.com/watch?v=-Cg6AoymaM0"),
                class = "justify-center items-center -m-8",
            ),
            DOM.div("Supporters"; class="text-xl text-black flex justify-center mt-14 mb-10 font-semibold"),
            FlexGrid(
                Logo(image="logos/numfocus.png", link="https://numfocus.org/project/julia"),
                Logo(image="logos/pumasai.svg", link="https://pumas.ai"),
                Logo(image="logos/juliahublogo.png", link="https://juliahub.com"),
                Logo(image="logos/beacon.svg", link="https://beacon.bio"),
                Logo(image="logos/mit.png", link=""),
                Logo(image="logos/bmbf.svg", link=""),
                class = "justify-center items-center -m-8",
            ),
            DOM.div("Follow us"; class="text-xl text-black flex justify-center mt-14 mb-10 font-semibold"),
            FlexGrid(
                SmallLogo(image="logos/twitter.svg", link="https://twitter.com/MakiePlots"),
                SmallLogo(image="logos/linkedin.png", link="https://www.linkedin.com/company/makieorg"),
                SmallLogo(image="logos/GitHub-Mark-64px.png", link="https://github.com/MakieOrg"),
                SmallLogo(image="logos/discord-mark-blue.svg", link="https://discord.gg/2FBjYAT3cY"),
                SmallLogo(image="logos/mastodon.svg", link="https://julialang.social/@makie"),

                class = "justify-center items-center -m-8",
            )
        );
        class="flex flex-col items-center w-full")
end
