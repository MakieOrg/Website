module Website

using Bonito, Markdown
import Bonito.TailwindDashboard as D
import GitHub

function asset_path(files...)
    path = normpath(joinpath(@__DIR__, "..", "assets", files...))
    folder = readdir(dirname(path))
    if !isempty(files)
        if !(basename(last(files)) in folder)
            error("$(repr(last(files))) not in $(folder)")
        end
    end
    return path
end

img_asset(files...) = Asset(asset_path("images", files...))
css_asset(files...) = Asset(asset_path("css", files...))

 # for Revise, since it doesn't track folders recursively
function asset_paths()
    return [@__DIR__, asset_path(), asset_path("css"), asset_path("js"), asset_path("images")]
end

include("styles.jl")
include("html-classes.jl")
include("index.jl")
include("github.jl")
include("support.jl")
include("team.jl")
include("contact.jl")
include("blog.jl")

export index, team, contact, support, asset_path, website_styles

end
