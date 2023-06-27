GHProject(x) = link(
    camelcase_break_suggest(splitdir(x)[end]),
    "https://github.com/$(x)"
)

team = App(title="Team") do
    c = ","
    projects = [
        GHProject("MakieOrg/Makie.jl"), c,
        GHProject("JuliaGPU/GPUArrays.jl"), c,
        GHProject("JuliaIO/FileIO.jl"), c,
        GHProject("SimonDanisch/JSServe.jl"), c,
        GHProject("JuliaLang/PackageCompiler.jl"), c,
        GHProject("JuliaGPU/CLArrays.jl"), c,
        GHProject("JuliaGeometry/GeometryBasics.jl"), c,
        GHProject("JuliaGraphics/FreeTypeAbstraction.jl"), c,
        GHProject("SimonDanisch/Matcha.jl"), c,
        GHProject("JuliaGeometry/Tetgen.jl"), c,
        GHProject("JuliaGeometry/EarCut.jl"), c,
        GHProject("JuliaGL/ModernGL.jl")
    ]

    simon = Section(
        FocusBlock(
            [
                H2Focus("Simon Danisch - Author of Makie"),
                DOM.p(
                """
                I began my studies in Cognitive Science at the University of Osnabrück in 2010, with a focus on computer vision and machine learning.
                In search of a language that could deliver superior performance for interactive computer vision and GPU computing, along with a mathematically elegant alternative to OOP,
                I discovered Julia in 2012. It's been my language of choice ever since.
                Working with C++ on machine learning projects in 2011, I experienced a lack of interactive tools for data visualization and model parameter manipulation.
                This led to my Bachelor's thesis, where I developed a Makie predecessor - containing code that is still utilized in Makie today.
                Since then, I've contributed significantly to the development of Julia's graphic, GPU, and plotting infrastructure, and authored numerous related packages:""",
                DOM.br(),
                projects,
                "and ", GHProject("SimonDanisch/FixedSizeArrays.jl"), "which became ", GHProject("JuliaArrays/StaticArrays.jl"))
            ];
            link="https://github.com/SimonDanisch",
            image="simon.jpg",
            rev=true
        )
    )
    julius = Section(
        FocusBlock(
            [
                H2Focus("Julius Krumbiegel - Co-Author"),
                DOM.p(
                "I joined the Makie project in 2019 when I created its layout system ",
                GHProject("jkrumbiegel/GridLayoutBase.jl"),
                " and most of the GUI objects currently available in what used to be the separate package ",
                GHProject("jkrumbiegel/MakieLayout.jl"),
                ". Owing to my academic history in psychology and vision science, my focus is on 2D plots and visual quality, which is why much of my work has revolved around our default themes, plot recipes, text and figure layouting as well as vector graphics output through CairoMakie.jl. ",
                "I'm also the author of packages such as ",
                [
                    GHProject("jkrumbiegel/Chain.jl"), c,
                    GHProject("jkrumbiegel/DataFrameMacros.jl"), c,
                    GHProject("jkrumbiegel/ReadableRegex.jl"), c,
                    GHProject("jkrumbiegel/Animations.jl"), " and ",
                    GHProject("jkrumbiegel/SankeyMakie.jl"), "."
                ]
                )
            ];
            link="https://github.com/jkrumbiegel",
            image="julius.jpg"
        )
    )
    coauthored = [
        GHProject("ffreyer/SphereSurfaceHistogram.jl"), c,
        GHProject("carstenbauer/BinningAnalysis.jl"), c,
        GHProject("carstenbauer/MonteCarlo.jl"), c,
        GHProject("ffreyer/LatPhysPlottingMakie.jl"),
    ]
    contributions = [
        GHProject("MakieOrg/Makie.jl"), c,
        GHProject("fatteneder/MakieSlides.jl"), c,
        GHProject("JuliaPlots/MakieTeX.jl"), c,
        GHProject("JuliaIO/MeshIO.jl"), c,
        GHProject("JuliaGizmos/Observables.jl"), c,
        GHProject("JuliaGeometry/GeometryBasics.jl"),
    ]
    frederic = Section(
        FocusBlock(
            [
                H2Focus("Frederic Freyer - GLMakie expert"),
                DOM.p(
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
                """)
            ];
            image="frederic.jpg",
            rev=true
        )
    )

    contributors = Section(
        H2("Makie Contributors"),
        FlexGrid(DOM.div.(owners, class="px-4 py-1")...)
    )
    return page(DOM.div(simon, julius, frederic, contributors; class="flex flex-col items-center w-full"), "Team")
end
