using JSServe, Markdown, Observables
using JSServe: ES6Module, Asset

module Types
    struct Card
        title::String
        description::String
        image::String
        link::String
    end
end

src_path(files...) = joinpath(@__DIR__, "src", files...)
site_path(files...) = normpath(joinpath(@__DIR__, "docs", files...))
markdown(files...) = joinpath(@__DIR__, "pages", "blogposts", files...)
asset(files...) = Asset(normpath(joinpath(@__DIR__, "assets", files...)))
const Highlight = ES6Module(joinpath(@__DIR__,  "assets", "libs", "highlight", "highlight.pack.js"))

function make_app(dom)
    return JSServe.App() do
        assets = asset.([
            "css/makie.css",
            "libs/highlight/github.min.css"])

        highlight = DOM.div(
            DOM.script(src=asset("libs", "highlight", "highlight.pack.js")),
            DOM.script("hljs.highlightAll()")
        )
        return DOM.html(
            DOM.head(
                DOM.meta(charset="UTF-8"),
                DOM.meta(name="viewport", content="width=device-width, initial-scale=1"),
                assets...,
                DOM.link(rel="icon", type="image/x-icon", href=asset("images", "favicon.ico")),
            ),
            DOM.body(dom, highlight)
        )
    end
end

function page(file)
    source = read(file, String)
    md = JSServe.string_to_markdown(source, Main; eval_julia_code=Main)
    banner = DOM.a(DOM.img(src = asset("images", "bannermesh_gradient.png")), href="/")
    body = DOM.div(DOM.div(md, class="inner-page"), class="outer-page")
    return make_app(DOM.div(banner, body))
end

assets = asset.(["css/makie.css"])
push!(assets, Asset("https://cdn.tailwindcss.com"; mediatype=:css))

function JSServe.jsrender(s::Session, card::Types.Card)
    return DOM.div(class = "box",
        DOM.a(
            DOM.div(card.title; class = "title"),
            DOM.div(
                DOM.div(card.description),
                JSServe.jsrender(s, DOM.img(src = asset(card.image), width=300)),
                ; class = "box-content");
            href = card.link, class = "box-link")
    )
end


function _index()
    App() do
        cards = [
            Types.Card("Simon Danisch", "Author of Makie", "images/simon.jpg", "simon.html"),
            Types.Card("Julius Krumbiegel", "Author of MakieLayout", "images/julius.jpg", "julius.html")
        ]
        return DOM.div(
            assets...,
            DOM.img(src = Observable(asset("images", "bannermesh_gradient.png"))),
            DOM.div(cards..., class = "mfp-content"))
    end
end

begin
    routes = JSServe.Routes()
    routes["index"] = _index()
    routes["simon"] = page(src_path("team", "simon.md"))
    routes["julius"] = page(src_path("team", "julius.md"))
    JSServe.export_static(site_path(), routes)
end
