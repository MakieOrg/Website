using JSServe
import JSServe.TailwindDashboard as D
JSServe.browser_display()
using Markdown

function md2html(s, file)
    source = read(file, String)
    return JSServe.string_to_markdown(s, source; eval_julia_code=Main)
end

Base.@kwdef struct Logo
    title::String=""
    description::String=""
    image::String=""
    link::String=""
    size::Int=80
    class::String="p-1 m-1 bg-gray-400"
end

Logo(; title="", description="", image="", link="", size=80, class="p-1 m-1 bg-gray-400") = Logo(title, description, image, link, size, class)

SmallLogo(; kw...) = Logo(; size=32, class="", kw...)

JSServe.jsrender(s::Session, card::Vector) = JSServe.jsrender(s, DOM.div(JSServe.TailwindCSS, card...; class="flex flex-wrap"))

img_asset(files...) = Asset(normpath(joinpath(@__DIR__, "assets", "images", files...)))
css_asset(files...) = Asset(normpath(joinpath(@__DIR__, "assets", "css", files...)))

function JSServe.jsrender(s::Session, card::Logo)
    return D.Card(DOM.div(
        DOM.a(
            DOM.div(card.title; class="title"),
            DOM.div(
                DOM.div(card.description),
                    JSServe.jsrender(s, DOM.img(src=img_asset(card.image), style="height: $(card.size)px; max-width: none")),
                ; class="box-content");
            href=card.link, class="box-link")
        ); class=card.class)
end

Base.@kwdef struct DetailedCard
    title::String = ""
    image::String = ""
    link::String = ""
    width::Int = 400
    details::Any = nothing
end

function JSServe.jsrender(s::Session, card::DetailedCard)
    return JSServe.jsrender(s, D.Card(
        D.FlexCol(
            css_asset("detail-hover.css"),
            DOM.div(card.title, class="text-lg text-bold"),
            DOM.div(
                DOM.img(src=img_asset(card.image); class="image",
                style="max-width: none; height: $(card.width)px; max-height: none"),
                DOM.div(JSServe.jsrender(s, card.details), class="overlay"),
            class="container")
        )
    ))
end

using FileWatching

function watcher(f, path)
    Base.errormonitor(@async begin
        while isfile(path)
            state = watch_file(path)
            if state.changed
                f()
            end
        end
    end)
end


function Navigation(highlighted="")
    function item(name, href="#$name")
        highlight = highlighted == name ? " navbar-highlight" : ""
        return DOM.a(DOM.div(
                class="text-white cursor-pointer p-1 hover:text-blue-200$highlight",
            name,
            ); href=href)
    end
    return DOM.div(
        class="pl-2 flex items-center navbar", # TailwindCSS classes
        DOM.div(
            class="flex",
            item("Home", "/"),
            item("Features"),
            item("Users"),
            item("Supporters"),
            item("Team", "/team.html"),
            item("Support"),
            item("Contact"),
        )
    )
end


function page(body, highlighted)
    header = DOM.img(src=img_asset("bannermesh_gradient.png"); style="width: 100%")
    return DOM.div(
        JSServe.TailwindCSS,
        JSServe.MarkdownCSS,
        css_asset("site.css"),
        header,
        Navigation(highlighted),
        body,
    )
end
path = joinpath(@__DIR__, "src", "index.md")
index = App() do s
    body = md2html(s, path)
    return page(body, "Home")
end
team = App() do
    body = DOM.div(
        DOM.div(
            DetailedCard(
                title="Simon Danisch",
                image="simon.jpg",
            ),
            DetailedCard(
                title="Julius Krumbiegel",
                image="julius.jpg",
            ),
            DetailedCard(
                title="Frederic Freyer",
                image="frederic.jpg",
            );
            class="flex flex-wrap"
        )
    )
    return page(body, "Team")
end

function make()
    dir = joinpath(@__DIR__, "docs")
    # rm(dir; recursive=true, force=true); mkdir(dir)
    routes = JSServe.Routes()
    routes["/"] = index
    routes["team"] = team
    folder = AssetFolder(dir)
    JSServe.export_static(dir, routes; asset_server=folder)
end

make()

disp = display(app)

watcher(path) do
    @async begin
        @time display(disp, app)
    end
end
