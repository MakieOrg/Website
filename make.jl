using JSServe, Markdown
JSServe.browser_display()

library(name, paths...) = JSServe.Dependency(name, joinpath.(@__DIR__, "site", "libs", collect(paths)))
asset(files...) = JSServe.Asset(joinpath(@__DIR__, "site", files...))
markdown(files...) = Markdown.parse_file(joinpath(@__DIR__, "src", files...))

assets = asset.([
    "css/franklin.css",
    "css/makie.css",
    "css/minimal-mistakes.css",
])

hljs = library(:hljs, "highlight/highlight.pack.js", "highlight/github.min.css")

App() do
    return DOM.div(
        assets...,
        DOM.img(src=asset("assets", "bannermesh_gradient.png")),
        markdown("index.md"),
        js"$(hljs).highlightAll()"
    )
end
