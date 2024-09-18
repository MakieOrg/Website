module Website

using Bonito, Markdown
import Bonito.TailwindDashboard as D
import GitHub

asset_path(files...) = normpath(joinpath(@__DIR__, "..", "assets", files...))
img_asset(files...) = Asset(asset_path("images", files...))
css_asset(files...) = Asset(asset_path("css", files...))

 # for Revise, since it doesn't track folders recursively
function asset_paths()
    return [asset_path(), asset_path("css"), asset_path("js"), asset_path("images")]
end

include("html-classes.jl")
include("index.jl")
include("github.jl")
include("support.jl")
include("team.jl")
include("contact.jl")

export index, team, contact, support, asset_path

end
