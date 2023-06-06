using GitHub

function JSServe.jsrender(owner::GitHub.Owner)
    name = DOM.span(string(owner.login), style="margin: 2px; color: 'gray")
    img = DOM.img(src=owner.avatar_url, style="border-radius: 50%", width=22)
    img_name = DOM.div(img, name; style="display: flex; align-items: center")
    return DOM.span(
        DOM.a(img_name, href=owner.html_url; style="color: gray; text-decoration: none"))
end

const GITHUB_OWNERS = Dict{String,GitHub.Owner}()
function gh_owner(name)
    get!(GITHUB_OWNERS, name) do
        println("api call")
        GitHub.owner(name)
    end
end


function all_contributors(repo::String)
    repo(repo)
    contributors(repo)
end

if !isdefined(Main, :makie_repo)
    makie_repo = repo("MakieOrg/Makie.jl")

    contribs = contributors(makie_repo)

    owners = [owner["contributor"] for owner in contribs[1]]
end
