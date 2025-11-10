title = "Makie Blog"
link = "https://blog.makie.org"
description = "A Blog about anything new in the Makie world"

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
# routes, task, server = interactive_server(Website.asset_paths()) do
#     return create_routes()
# end

##
dir = joinpath(@__DIR__, "build")
!isdir(dir) && mkdir(dir)
Bonito.export_static(dir, create_routes())

## TODO, add xml to routes
rss_path = joinpath(dir, "rss.xml")
entries = last.(Website.all_posts())
BonitoSites.generate_rss_feed(entries, rss_path; title, link, description, relative_path="./website/")

##
BonitoSites.deploy(
    "github.com/MakieOrg/Website.git";
    push_preview=true,
    devbranch="main",
    devurl="website"
)
