using Revise, JSServe, Markdown
ENV["JULIA_DEBUG"] = JSServe
import JSServe.TailwindDashboard as D

include("src/html-classes.jl")
# include("src/index.jl")
# include("src/github.jl")
# include("src/support.jl")
# include("src/team.jl")
# include("src/contact.jl")


# routes, task, server = interactive_server([asset_path(), joinpath(@__DIR__, "src")]) do
#     return Routes(
#         "/" => index,
#         "/team" => team,
#         "/contact" => contact,
#         "/support" => support
#     )
# end

# routes = Routes(
#     "/" => index,
#     "/team" => team,
#     "/contact" => contact,
#     "/support" => support
# )

# dir = joinpath(@__DIR__, "docs")
# JSServe.export_static(dir, routes)
__revise_mode__ = :evalassign
Revise.tracking_Main_includes[] = true
key = Revise.add_callback([asset_path(), joinpath(@__DIR__, "src")]; all=true) do
    println("##############")
    println("callback")
    println("test: $(test())")
    write(stdout, read(asset_path("test.css")))
    println("##############")
end

revise()
test()
1 + 1
