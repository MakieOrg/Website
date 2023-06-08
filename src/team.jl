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
        Block(
        H2("Simon Danisch - Author of Makie"),
        FocusBlock(DOM.p(
            """
            I'm a Julia open source developer since 2012 and have helped build substantial parts of the graphics, GPU and plotting infrastructure in Julia.
            I'm  the author of: \n""",
            DOM.br(),
            projects);
            link="https://github.com/SimonDanisch",
            image="simon.jpg",
            rev=true
            ))
    )
    julius = Section(
        Block(
        H2("Julius Krumbiegel - Co-Author"),
        FocusBlock(
            """

            """;
            link="https://github.com/jkrumbiegel",
            image="julius.jpg"
        ))
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
        Block(
        H2("Frederic Freyer - GLMakie expert"),
        FocusBlock(
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
            """);
            image="frederic.jpg",
            rev=true
            ))
    )

    contributors = Section(
        H2("Makie Contributors"),
        FlexGrid(DOM.div.(owners, class="px-4 py-1")...)
    )
    return page(DOM.div(simon, julius, frederic, contributors; class="flex flex-col items-center w-full"), "Team")
end
