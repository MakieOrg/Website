using Website
using Website.Bonito

begin
    println("####################")
    println(Website.img_asset())
    println(readdir(Website.img_asset().local_path))
    println(readdir(Website.img_asset("logos").local_path))
    println("####################")
end

# Use for interactive dev
# routes, task, server = interactive_server(Website.asset_paths()) do
#     return Routes(
#         "/" => App(index, title="Makie"),
#         "/team" => App(team, title="Team"),
#         "/contact" => App(contact, title="Contact"),
#         "/support" => App(support, title="Support")
#     )
# end

routes = Routes(
    "/" => App(index, title="Makie"),
    "/team" => App(team, title="Team"),
    "/contact" => App(contact, title="Contact"),
    "/support" => App(support, title="Support")
)

##
dir = joinpath(@__DIR__, "build")
!isdir(dir) && mkdir(dir)
Bonito.export_static(dir, routes)
cp(joinpath(@__DIR__, "..", "assets", "images", "favicon.ico"), joinpath(dir, "favicon.ico"); force=true)

using Documenter

docs_url = "makie.org"
repo = "github.com/MakieOrg/Website.git"
push_preview = true
devbranch = "main"
devurl = "dev"
include("utils.jl")

params = deployparameters(; repo, devbranch, devurl, push_preview)
deploy_decision = Documenter.DeployDecision(;
    params.all_ok,
    params.branch,
    params.is_preview,
    params.repo,
    params.subfolder,
)

deploy(params; target="build")
