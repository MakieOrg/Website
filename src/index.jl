
using JSServe: @dom_str

semibold(text) = DOM.span(text, class="font-semibold")

function index()
    Julia = link("Julia", "https://julialang.org")
    be_quote = link(DOM.img(src=img_asset("benedikt-tweet.png"); class=CARD_STYLE), "https://twitter.com/BenediktEhinger/status/1665326068973158400")

    intro = Section(
        Spacer(4),
        FullWidthText(
            dom"""
            $(semibold("Makie")) is a modern plotting library for $Julia.
            It is easy to use, fast and powerful. Packed with features,
            it is a general-purpose tool that makes as few compromises for specialized use cases as possible.
            """),
        Spacer(6),
        Grid(
            Showcase(
                title="Explore large datasets",
                image="use_cases/datashader.mp4",
            ),
            Showcase(
                title="Export for publications",
                image="use_cases/publication.jpg",
                href="https://agupubs.onlinelibrary.wiley.com/doi/10.1029/2022MS003527",
            ),
            Showcase(
                title="Render photorealistic images",
                image="backends/rprmakie.png",
                href="https://www.bgc-jena.mpg.de/en/bgi/gallery",
            ),
            Showcase(
                title="Create web dashboards",
                image="use_cases/clima.mp4",
                href="https://github.com/SimonDanisch/Bonito.jl",
            ),
            class = "gap-6 md:gap-10 sm:grid-cols-2",
        ),
        Spacer(4)
    )
    backend_class = "w-full"

    benedict = QuoteBlock(
        "Benedict Ehinger",
        "https://github.com/behinger",
        """
        The only way I succeeded to do this without manually replacing fonts in illustrator, is to use
        @MakiePlots with it's fabulous layout-system.
        """,
        "https://twitter.com/BenediktEhinger/status/1665326068973158400"
    )

    alex = QuoteBlock(
        "Alex S. Gardner",
        "https://www.linkedin.com/posts/alex-s-gardner_greenland-julia-itsabrlive-activity-7056483156798947328-99pH",
        """
         I'm pretty stoked about this capability as it offers a new way of interactively visualizing animated geospatial data that I haven't seen done in any other language.
        """,
        "https://julialang.slack.com/archives/C9XBLUCVB/p1682465705219249"
    )

    garrek = QuoteBlock(
        "Garrek Stemo",
        "https://github.com/garrekstemo",
        """
        Makie was what convinced me to completely switch from Python to Julia.
        It is simple and looks great out of the box.
        I was pretty quickly able to make a simple GUI that integrates with my laboratory instruments to automatically spit out plots.
        """,
        "https://discourse.julialang.org/t/comparison-of-plotting-packages/99860/44"
    )
    features = Section(bg="bg-gray-100",
        H1("Features"),
        FocusBlock(
            DOM.div(
                H2Focus("Surgical updates & high performance"),
                """
                Makie uses Observables.jl to only update what's necessary at a given point in time.
                This example animates hundreds of thousands of points just through a colormap update, modifying only a few bytes per frame directly on the GPU.
                There's no faster way to animate large data. Combining the power of GPUs and Julia's high performance, Makie is fit for any task!
                """,
                alex;
                class="flex flex-col gap-1",
            );
            image="use_cases/glacier.mp4",
            link="https://makieorg.github.io/Tyler.jl/v0.1.4/iceloss_ex",
            rev=true
        ),
        Spacer(10),
        FocusBlock(
            DOM.div(
                H2Focus("Powerful Layouting"),
                """
                Makie has one of the most powerful layouting systems compared to other plotting
                libraries, allowing you to tweak any possible attribute and place your plots
                and subplots freely.
                """,
                benedict;
                class="flex flex-col gap-1",
            );
            image="use_cases/layouting.png",
            link="https://docs.makie.org/stable/tutorials/layout-tutorial/"
        ),
        Spacer(10),
        FocusBlock(
            DOM.div(
                H2Focus("2D, 3D, Volumes, Meshes, Sliders, Buttons and more"),
                """
                Makie has support for all kind of primitives for interactive data exploration. This makes it simple to quickly build up dashboards for any kind of data.
                """,
                garrek;
                class="flex flex-col gap-1",
            ),
            image="use_cases/clima-volume.mp4",
            rev=true
        ),
        Spacer(10),
        FocusBlock(
            DOM.div(
                H2Focus("Powerful event system and rendering engine"),
                """
                Makie is certainly not a game engine, but its rich rendering and interaction features allow the creation of simple, interactive games such as Minecraft.
                While Makie might not be the go-to for more complex games, using it to build a Minecraft-like game highlights its versatility for complex, interactive visualizations.
                Many use cases, such as AI gyms or complex, interactive 3D simulations, greatly benefit from this.
                """,
                class="flex flex-col gap-1",
            ),
            link="https://github.com/ashwani-rathee/Miner.jl",
            image="use_cases/miner.png",
        ),
        Spacer(10)
    )
    backends = Section(
        H1("Backends"),
        FullWidthText(
            """Makie's backends are the reason why we can have high quality vector graphics for publication while also delivering fast GPU accelerated renderings.
            Use exactly the same code and change how your interactive graphic is displayed simply by switching the backend.
            """,
            class="my-4"
        ),
        FocusBlock(
            DOM.div(
                H2Focus("GLMakie"),
                DOM.span(
                    """The backend for fast, interactive desktop applications.
                    It was Makie's first backend and uses the GPU via OpenGL for fast 3D animations.
                    It supports basic UI elements for simple Dashboards.
                    Either a hardware or virtual GPU (e.g. Mesa, VirtualGL) is necessary to use GLMakie.
                    (Image from:
                    """,
                    link("A. N. Souza", "https://agupubs.onlinelibrary.wiley.com/doi/10.1029/2022MS003527"),
                    ")",
                );
                class="flex flex-col gap-1",
            ),
            image="backends/glmakie.png",
            link="https://docs.makie.org/stable/documentation/backends/glmakie/",
            rev=true
        ),
        Spacer(10),
        FocusBlock(
            DOM.div(
                H2Focus("CairoMakie"),
                DOM.span(
                    """
                    CairoMakie runs anywhere on the CPU and is Makie's backend for SVG and PDF vector graphics output.
                    With CairoMakie, you can achieve the highest quality output for publications and reports.
                    Because it uses vector graphics primitives, CairoMakie does not support 3D rendering the same way as GLMakie
                    and has no interactive mode.
                    (Image from:
                    """,
                    link("beautiful.makie.org", "https://beautiful.makie.org"),
                    ")",
                );
                class="flex flex-col gap-1",
            ),
            image="backends/cairomakie.svg",
            link="https://docs.makie.org/stable/documentation/backends/cairomakie/",
            rev=false
        ),
        Spacer(10),
        FocusBlock(
            DOM.div(
                H2Focus("WGLMakie"),
                DOM.span(
                    """
                    WGLMakie puts your visualizations in the browser using Threejs and WebGL.
                    It runs almost anywhere on the GPU and is great for working on remote machines,
                    with Pluto or Jupyter notebooks, or in browser-like IDEs such as VSCode.
                    Like with all javascript-based visualization tools, there is an overhead when transferring large amounts of data to the browser.
                    (Image from:
                    """,
                    link("VISUS", "https://www.visus.uni-stuttgart.de"),
                    ")",
                );
                class="flex flex-col gap-1",
            ),
            image="backends/wglmakie.mp4",
            link="https://docs.makie.org/stable/documentation/backends/wglmakie/",
            rev=true
        ),
        Spacer(10),
        FocusBlock(
            DOM.div(
                H2Focus("RPRMakie"),
                dom"""
                    RPRMakie is the newest experimental backend for raytraced images using $(link("RadeonProRender", "https://github.com/GPUOpen-LibrariesAndSDKs/RadeonProRenderSDK")) from AMD.
                    RadeonProRender is not only a production ready high quality raytracing engine, but even though the name suggests otherwise, its truely cross platform and runs on AMD/NVIDIA GPUs and any CPU.
                    With appropriately fast hardware, you can render beautiful visualizations that show off your data
                    using physically accurate materials and lights.
                    (Image from: $(link("Lazaro Alonso", "https://github.com/lazarusA")))
                """,
                class="flex flex-col gap-1",
            ),
            image="use_cases/earths_creditst.png",
            link="https://docs.makie.org/stable/documentation/backends/rprmakie/",
            rev=false
        ),
    )
    eco_class = ""
    ecosystem = Section(bg="bg-gray-100",
        H1("Rich Ecosystem"),
        FullWidthText("""
        Makie is highly modular and extensible.
        Many use cases are already covered by its inbuilt plot types and interactive elements.
        For more specialized applications, have a look at the rich third-party ecosystem that has developed around Makie:
        """, class="my-4"),
        Grid(
            DetailedCard(
                title="GeoMakie.jl",
                link="https://github.com/MakieOrg/GeoMakie.jl",
                image="ecosystem/geomakie.png",
                imclass=eco_class,
                details="Geographical plotting utilities for Makie.jl",
            ),
            DetailedCard(
                title="Tyler.jl",
                link="https://github.com/MakieOrg/Tyler.jl",
                image="ecosystem/tyler-sam.mp4",
                imclass=eco_class,
                details="Makie package to plot maptiles from various map providers"
            ),
            DetailedCard(
                title="FerriteViz.jl",
                link="https://github.com/Ferrite-FEM/FerriteViz.jl",
                image="ecosystem/ferrite.mp4",
                imclass=eco_class,
                details=md"Small package to visualize [Ferrite.jl](https://github.com/Ferrite-FEM/Ferrite.jl) results, which is a simple finite element toolbox written in Julia."
            ),
            DetailedCard(
                title="GraphMakie.jl",
                link="https://github.com/MakieOrg/GraphMakie.jl",
                image="ecosystem/graphmakie.png",
                imclass=eco_class,
                details="Plotting graphs with Makie"
            ),
            DetailedCard(
                title="BioMakie.jl",
                link="https://github.com/kool7d/BioMakie.jl",
                image="ecosystem/biomakie.png",
                imclass=eco_class,
                details="User interface tools for bioinformatics"
            ),
            DetailedCard(
                title="TopoPlots.jl",
                link="https://github.com/MakieOrg/TopoPlots.jl",
                image="ecosystem/topoplots.png",
                imclass=eco_class,
                details="Makie topo plot recipes, for neuro-science, geo plots and anyone needing surface plots from unstructured data"
            ),
            DetailedCard(
                title="ModelingToolkitDesigner.jl",
                link="https://github.com/bradcarman/ModelingToolkitDesigner.jl",
                image="ecosystem/modelingtoolkitdesigner.svg",
                imclass=eco_class,
                details="A helper tool for visualizing and editing a ModelingToolkit.jl system connections"
            ),
            DetailedCard(
                title="PairPlots.jl",
                link="https://sefffal.github.io/PairPlots.jl/",
                image="ecosystem/pairplots.png",
                imclass=eco_class,
                details="Beautiful and flexible vizualizations of high dimensional data"
            ),
            DetailedCard(
                title="AlgebraOfGraphics.jl",
                link="https://aog.makie.org/",
                image="ecosystem/aog.png",
                imclass=eco_class,
                details="AlgebraOfGraphics defines a language for data visualization. It is based on a few simple building blocks that can be combined using + and *."
            ),
            DetailedCard(
                title="TidierPlots.jl",
                link="https://github.com/TidierOrg/TidierPlots.jl",
                image="ecosystem/tidier.png",
                imclass=eco_class,
                details="100% Julia implementation of the ggplot2 R package"
            ),
            DetailedCard(
                title="Meshes.jl",
                link="https://github.com/JuliaGeometry/Meshes.jl",
                image="ecosystem/meshviz.png",
                imclass=eco_class,
                details="Makie.jl recipes for visualization of Meshes.jl"
            ), DetailedCard(
                title="OSMMakie.jl",
                link="https://github.com/MakieOrg/OSMMakie.jl",
                image="ecosystem/osmmakie.png",
                imclass=eco_class,
                details="A Makie.jl recipe for plotting OpenStreetMap data."
            ),
            DetailedCard(
                title="GeneticsMakie.jl",
                image="ecosystem/geneticsmakie.png",
                link="https://github.com/mmkim1210/GeneticsMakie.jl",
                imclass=eco_class,
                details="🧬High-performance genetics-related data visualization using Makie.jl"
            ),
            DetailedCard(
                title="IncompressibleNavierStokes.jl",
                link="https://github.com/agdestein/IncompressibleNavierStokes.jl",
                image="ecosystem/incompressiblenavierstokes.mp4",
                imclass=eco_class,
                details="Incompressible Navier-Stokes solver, utilizing Makie for interactive visualizations"
            ),
            DetailedCard(
                title="InteractiveViz.jl",
                link="https://github.com/org-arl/InteractiveViz.jl",
                image="ecosystem/interactiveviz.png",
                imclass=eco_class,
                details="Interactive visualization tools for Julia"
            ),
            DetailedCard(
                title="MakiePublications.jl",
                link="https://github.com/liuyxpp/MakiePublication.jl",
                image="ecosystem/makiepublications.svg",
                imclass=eco_class,
                details="A Julia package for producing publication quality figures based on Makie.jl."
            ),
            DetailedCard(
                title="UnfoldMakie.jl",
                link="https://github.com/unfoldtoolbox/UnfoldMakie.jl",
                image="ecosystem/unfoldmakie.png",
                imclass=eco_class,
                details="Plotting tools for Unfold.jl based on Makie.jl and AlgebraOfGraphics.jl"
            ),
            DetailedCard(
                title="NestedGraphMakie.jl",
                link="https://github.com/UniStuttgart-IKR/NestedGraphMakie.jl",
                image="ecosystem/nestedgraphmakie.png",
                imclass=eco_class,
                details="A package for NestedGraphs.jl to make easy visualizations."
            ),
            DetailedCard(
                title="MakieDraw.jl",
                link="https://github.com/MakieOrg/MakieDraw.jl",
                image="ecosystem/makiedraw.mp4",
                imclass=eco_class,
                details="Plot an interactive canvas of GeometryBaseics Point, LineString or Polygon, or an ms-paint style canvas for any numerical or color Array"
            ),
            DetailedCard(
                title="Agents.jl",
                link="https://juliadynamics.github.io/Agents.jl/",
                image="ecosystem/agents.png",
                imclass=eco_class,
                details="Agents.jl is a pure Julia framework for agent-based modeling (ABM)"
            ),
            class="gap-4 grid-cols-2 sm:grid-cols-3 md:grid-cols-4",
        ),
    )
    users = Section(bg="white",
        DOM.div("Users"; class="text-xl text-black flex justify-center mt-14 mb-10 font-semibold"),
        FlexGrid(
            Logo(image="logos/climaalliancelogo.png", link="https://clima.caltech.edu"),
            Logo(image="logos/mpg_biogeochemistry.png", link="https://www.bgc-jena.mpg.de/en/bgi/gallery"),
            Logo(image="logos/nasa_jpl.png", link="https://www.jpl.nasa.gov/"),
            Logo(image="logos/microsoft.png", link="https://www.youtube.com/watch?v=7-vN8oNAz6Y"),
            Logo(image="logos/instron.png", link="https://github.com/bradcarman/ModelingToolkitDesigner.jl"),
            Logo(image="logos/dwd.png", link="https://www.youtube.com/watch?v=-Cg6AoymaM0"),
            class="justify-center items-center -m-2 lg:-m-8",
        ),
        DOM.div("Supporters"; class="text-xl text-black flex justify-center mt-14 mb-10 font-semibold"),
        FlexGrid(
            Logo(image="logos/numfocus.png", link="https://numfocus.org/project/julia"),
            Logo(image="logos/pumasai.svg", link="https://pumas.ai"),
            Logo(image="logos/juliahublogo.png", link="https://juliahub.com"),
            Logo(image="logos/beacon.svg", link="https://beacon.bio"),
            Logo(image="logos/mit.png", link=""),
            Logo(image="logos/bmbf.svg", link=""),
            class="justify-center items-center -m-2 lg:-m-8",
        ),
        DOM.div("Follow us"; class="text-xl text-black flex justify-center mt-14 mb-10 font-semibold"),
        FlexGrid(
            SmallLogo(image="logos/twitter.svg", link="https://twitter.com/MakiePlots"),
            SmallLogo(image="logos/linkedin.png", link="https://www.linkedin.com/company/makieorg"),
            SmallLogo(image="logos/GitHub-Mark-64px.png", link="https://github.com/MakieOrg"),
            SmallLogo(image="logos/discord-mark-blue.svg", link="https://discord.gg/2FBjYAT3cY"),
            SmallLogo(image="logos/mastodon.svg", link="https://julialang.social/@makie"), class="justify-center items-center -m-2 md:-m-4 lg:-m-8",
        )
    )
    body = DOM.div(
        intro,
        features,
        backends,
        ecosystem,
        users;
    )
    return page(body, "Home")
end
