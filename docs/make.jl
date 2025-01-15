using Website
using Website.Bonito
using Website.BonitoSites

function create_routes()
    routes = Routes(
        "/" => App(index, title="Makie"),
        "/team" => App(team, title="Team"),
        "/contact" => App(contact, title="Contact"),
        "/support" => App(support, title="Support"),
        "/blog" => App(blog, title="Blog"),
    )

    Website.add_blogposts!(routes)
end

# Use for interactive dev
# using Revise
routes, task, server = interactive_server(Website.asset_paths()) do
    return create_routes()
end


##
dir = joinpath(@__DIR__, "build")
!isdir(dir) && mkdir(dir)
Bonito.export_static(dir, create_routes())

##
BonitoSites.deploy(
    "github.com/MakieOrg/Website.git";
    push_preview=true,
    devbranch="master",
    devurl="website"
)
