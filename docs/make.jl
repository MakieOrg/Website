using Website
using Website.Bonito

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
dir = joinpath(@__DIR__, "docs", "build")
!isdir(dir) && mkdir(dir)
# only delete the jsserve generated files
rm(joinpath(dir, "bonito"); recursive=true, force=true)
Bonito.export_static(dir, routes)
cp(joinpath(@__DIR__, "assets/images/favicon.ico"), joinpath(dir, "favicon.ico"); force=true)

using Documenter

docs_url = "makie.org"
repo = "github.com/MakieOrg/Website.git"
push_preview = true
devbranch = "master"
devurl = "dev"

params = deployparameters(; repo, devbranch, devurl, push_preview)
deploy_decision = Documenter.DeployDecision(;
    params.all_ok,
    params.branch,
    params.is_preview,
    params.repo,
    params.subfolder,
)

deploy(params; target="build")
