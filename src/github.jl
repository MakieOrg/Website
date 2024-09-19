
function Bonito.jsrender(owner::GitHub.Owner)
    name = DOM.span(string(owner.login), style="margin: 2px; color: 'gray")
    img = DOM.img(src=owner.avatar_url, style="border-radius: 50%", width=22)
    img_name = DOM.div(img, name; style="display: flex; align-items: center")
    return DOM.span(
        DOM.a(img_name, href=owner.html_url; style="color: gray; text-decoration: none"))
end

const GITHUB_OWNERS = Dict{String,GitHub.Owner}()

function gh_owner(name)
    get!(GITHUB_OWNERS, name) do
        GitHub.owner(name)
    end
end

function all_contributors(repo::String)
    repo(repo)
    contributors(repo)
end

const OWNERS = open(joinpath(@__DIR__, "contributor.json")) do io
    array = GitHub.JSON.parse(io)
    to_kw(o) = map(x -> Symbol(x[1]) => x[2], collect(pairs(o)))
    map(o -> GitHub.Owner(; to_kw(o)...), array)
end

#=
# contributor.json Created with the following code:
to_value(uri::GitHub.URIs.URI) = string(uri)
to_value(x) = x
function to_dict(d)
    o = d["contributor"]
    pairs = [f => to_value(getproperty(o, f)) for f in propertynames(o)]
    Dict(filter(((k, v),)-> (k!=:site_admin) && (!isnothing(v)), pairs))
end

makie_repo = GitHub.repo("MakieOrg/Makie.jl")
contribs = GitHub.contributors(makie_repo)
open("contributor.json", "w") do io
    JSON.print(io, map(to_dict, contribs[1]))
end
=#
