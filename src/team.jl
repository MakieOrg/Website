GHProject(x) = link(
    camelcase_break_suggest(splitdir(x)[end]),
    "https://github.com/$(x)"
)

# Inline list of links separated by ", " (the old "," join rendered without spaces)
function link_list(links)
    elems = Any[]
    for (i, l) in enumerate(links)
        i > 1 && push!(elems, ", ")
        push!(elems, l)
    end
    return DOM.span(elems...)
end

function team()
    projects = link_list(GHProject.([
        "MakieOrg/Makie.jl",
        "JuliaGPU/GPUArrays.jl",
        "JuliaIO/FileIO.jl",
        "SimonDanisch/Bonito.jl",
        "JuliaLang/PackageCompiler.jl",
        "JuliaGPU/CLArrays.jl",
        "JuliaGeometry/GeometryBasics.jl",
        "JuliaGraphics/FreeTypeAbstraction.jl",
        "SimonDanisch/Matcha.jl",
        "JuliaGeometry/Tetgen.jl",
        "JuliaGeometry/EarCut.jl",
        "JuliaGL/ModernGL.jl",
    ]))

    simon = Section(
        FocusBlock(
            [
                H2Focus("Simon Danisch, Author of Makie"),
                DOM.p(
                """
                I work as an independent developer on Makie and much of its surrounding Julia graphics, GPU and web ecosystem.
                I began my studies in Cognitive Science at the University of Osnabrück in 2010, with a focus on computer vision and machine learning.
                In search of a language that could deliver superior performance for interactive computing and great GPU integration, along with an elegant alternative to OOP for math,
                I discovered Julia in 2012. It's been my language of choice ever since.
                Working with C++ on machine learning projects in 2011, I experienced a lack of easy to use, interactive tools for data visualization and model parameter manipulation.
                This led to my Bachelor's thesis, where I developed a Makie predecessor - containing code that is still utilized in Makie today.
                Since then, I've contributed significantly to the development of Julia's graphic, GPU, and plotting infrastructure, and authored numerous related packages:""",
                DOM.br(),
                projects,
                " and ", GHProject("SimonDanisch/FixedSizeArrays.jl"), ", which later became ", GHProject("JuliaArrays/StaticArrays.jl"), ".")
            ];
            link="https://github.com/SimonDanisch",
            image="simon.jpg",
            rev=true
        )
    )
    julius = Section(
        FocusBlock(
            [
                H2Focus("Julius Krumbiegel, Co-Author"),
                DOM.p(
                "I currently work at [PumasAI](https://pumas.ai/) and maintain Makie's layout system and 2D graphics. ",
                "I joined the Makie project in 2019 when I created its layout system ",
                GHProject("jkrumbiegel/GridLayoutBase.jl"),
                " and most of the GUI objects currently available in what used to be the separate package ",
                GHProject("jkrumbiegel/MakieLayout.jl"),
                ". Owing to my academic history in psychology and vision science, my focus is on 2D plots and visual quality, which is why much of my work has revolved around our default themes, plot recipes, text and figure layouting as well as vector graphics output through CairoMakie.jl. ",
                "I'm also the author of packages such as ",
                link_list(GHProject.([
                    "jkrumbiegel/Chain.jl",
                    "jkrumbiegel/DataFrameMacros.jl",
                    "jkrumbiegel/ReadableRegex.jl",
                    "jkrumbiegel/Animations.jl",
                    "jkrumbiegel/SankeyMakie.jl",
                ])),
                "."
                )
            ];
            link="https://github.com/jkrumbiegel",
            image="julius.jpg"
        )
    )
    coauthored = link_list(GHProject.([
        "ffreyer/SphereSurfaceHistogram.jl",
        "carstenbauer/BinningAnalysis.jl",
        "carstenbauer/MonteCarlo.jl",
        "ffreyer/LatPhysPlottingMakie.jl",
    ]))
    contributions = link_list(GHProject.([
        "MakieOrg/Makie.jl",
        "fatteneder/MakieSlides.jl",
        "JuliaPlots/MakieTeX.jl",
        "JuliaIO/MeshIO.jl",
        "JuliaGizmos/Observables.jl",
        "JuliaGeometry/GeometryBasics.jl",
    ]))
    frederic = Section(
        FocusBlock(
            [
                H2Focus("Frederic Freyer, GLMakie expert"),
                DOM.p(
                """
                I work as a freelance developer, focused on Makie's rendering backends and core internals.
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
        FlexGrid(DOM.div.(OWNERS, class="px-3 py-1 m-1 text-sm bg-gray-100 rounded-full")...; class="justify-center")
    )
    intro = Section(
        H1("Core Maintainers"),
        TextBlock(
        """
        Makie is developed and maintained by a small group of independent developers, each \
        focused on different parts of the library and its ecosystem, from rendering backends \
        to layout, geometry and the web stack. We work on Makie alongside our own jobs and \
        projects; below are the people behind it.
        """; width="w-full")
    )
    return page(DOM.div(intro, simon, julius, frederic, contributors; class="flex flex-col items-center w-full"), "Maintainers")
end
