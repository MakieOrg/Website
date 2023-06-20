GHProject(x) = link(splitdir(x)[end], "https://github.com/$(x)")

team = App(title="Team") do
    projects = [
        GHProject("MakieOrg/Makie.jl"), ", ",
        GHProject("JuliaGPU/GPUArrays.jl"), ", ",
        GHProject("JuliaIO/FileIO.jl"), ", ",
        GHProject("SimonDanisch/JSServe.jl"), ", ",
        GHProject("JuliaLang/PackageCompiler.jl"), ", ",
        GHProject("JuliaGPU/CLArrays.jl"), ", ",
        GHProject("JuliaGeometry/GeometryBasics.jl"), ", ",
        GHProject("JuliaGraphics/FreeTypeAbstraction.jl"), ", ",
        GHProject("SimonDanisch/Matcha.jl"), ", ",
        GHProject("JuliaGeometry/Tetgen.jl"), ", ",
        GHProject("JuliaGeometry/EarCut.jl"), ", ",
        GHProject("JuliaGL/ModernGL.jl")
    ]

    simon = Section(
        FocusBlock(
            [
                H2Focus("Simon Danisch - Author of Makie"),
                DOM.p(
                """
                I'm a Julia open source developer since 2012 and have helped build substantial parts of the graphics, GPU and plotting infrastructure in Julia.
                I'm  the author of: \n""",
                DOM.br(),
                projects)
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
                    GHProject("jkrumbiegel/Chain.jl"), ", ",
                    GHProject("jkrumbiegel/DataFrameMacros.jl"), ", ",
                    GHProject("jkrumbiegel/ReadableRegex.jl"), ", ",
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
        GHProject("ffreyer/SphereSurfaceHistogram.jl"), ", ",
        GHProject("carstenbauer/BinningAnalysis.jl"), ", ",
        GHProject("carstenbauer/MonteCarlo.jl"), ", ",
        GHProject("ffreyer/LatPhysPlottingMakie.jl"),
    ]
    contributions = [
        GHProject("MakieOrg/Makie.jl"), ", ",
        GHProject("fatteneder/MakieSlides.jl"), ", ",
        GHProject("JuliaPlots/MakieTeX.jl"), ", ",
        GHProject("JuliaIO/MeshIO.jl"), ", ",
        GHProject("JuliaGizmos/Observables.jl"), ", ",
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
