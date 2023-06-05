using JSServe
import JSServe.TailwindDashboard as D
JSServe.browser_display()
using Markdown

function md2html(s, file)
    source = read(file, String)
    return JSServe.string_to_markdown(s, source; eval_julia_code=Main)
end

H1(x) = DOM.h1(x; class="text-2xl font-black text-left my-2")
H2(x) = DOM.h2(x; class="text-lg font-bold text-left my-1")
JSServe.jsrender(s::Session, card::Vector) = JSServe.jsrender(s, DOM.div(JSServe.TailwindCSS, card...; class="flex flex-wrap"))

img_asset(files...) = Asset(normpath(joinpath(@__DIR__, "assets", "images", files...)))
css_asset(files...) = Asset(normpath(joinpath(@__DIR__, "assets", "css", files...)))
FlexGrid(elems...; class="", kwargs...) = DOM.div(elems...; class=join(["flex flex-wrap", class], " "), kwargs...)
TextBlock(text; width=600) = DOM.div(text; class="text-xl px-4", style="width: $(width)px")
Block(elems...) = DOM.div(elems...; class="p-2 m-2 w-5/6 max-w-5xl")
Section(content...; bg="") = DOM.div(Block(content...), class="$bg flex flex-col items-center w-full")
function Showcase(; title, image, link)
    img = render_media(img_asset(image); class="image p-2", style="height: 150px; ")
    return D.FlexCol(
        DOM.div(title, class="text-lg font-semibold text-center"),
        DOM.a(img; href=link)
    )
end


Base.@kwdef struct Logo
    image::String=""
    link::String=""
    class::String = "w-1/4 p-8 flex justify-center"
end

SmallLogo(; kw...) = Logo(; class="rounded-md p-2 m-2 shadow bg-white w-8", kw...)

function render_media(asset::Asset; class="", style="")
    if asset.media_type == :mp4
        return DOM.video(DOM.source(src=asset, type="video/mp4"); muted=true, controls=false, autoplay=true, loop=true, class=class, style=style)
    else
        return DOM.img(src=asset; class=class, style=style)
    end
end

function JSServe.jsrender(s::Session, logo::Logo)
    img = DOM.img(src=img_asset(logo.image), class="w-full")
    return JSServe.jsrender(s, DOM.div(
        DOM.a(img; href=logo.link, class="box-link w-full"),
        class=logo.class)
    )
end

Base.@kwdef struct DetailedCard
    title::String = ""
    image::String = ""
    link::String = ""
    width::Int = 400
    height = ""
    details::Any = nothing
end

function JSServe.jsrender(s::Session, card::DetailedCard)
    if isempty(card.height)
        style = "width: $(card.width)px"
    else
        style = "height: $(card.height)px"
    end
    img = render_media(img_asset(card.image); class="image p-4", style=style)
    details = if card.details isa Markdown.MD
        JSServe.md_html(Session(), card.details.content[1])
    else
        card.details
    end
    return JSServe.jsrender(s,
        DOM.div(class="rounded-md shadow m-2 bg-white flex grow justify-center",
            D.FlexCol(
                css_asset("detail-hover.css"),
                DOM.div(card.title, class="text-m font-semibold text-center mb-3"),
                DOM.div(img, DOM.div(details, class="overlay"),
                class="container"),
            )
        ))
end

function FocusBlock(description; image="", link="", height="400px", rev=false)
    block = [
        TextBlock(description),
        DOM.a(render_media(img_asset(image), class="rounded-md p-2 shadow bg-white", style="width: $height; max-width: none"); href=link)
    ]
    rev && reverse!(block)
    return D.FlexRow(block...)
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
                class="text-white cursor-pointer py-1 px-2 hover:text-blue-200$highlight",
            name,
            ); href=href)
    end
    return DOM.div(
        class="pl-8 flex items-center navbar", # TailwindCSS classes
        DOM.div(
            class="flex",
            item("Home", "./"),
            item("Team", "./team.html"),
            item("Support", "./support.html"),
            item("Contact", "./contact.html"),
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


include("src/index.jl")
index = App(title="Makie") do s
    # body = md2html(s, path)
    return page(index_page(), "Home")
end

##

team = App(title="Makie - Team") do s
    path = joinpath(@__DIR__, "src", "team.md")
    body = md2html(s, path)
    return page(body, "Team")
end

function SupportCard(title, content)
    D.Card(
        D.FlexCol(H1(title),
        TextBlock(content; width=400)),
    )
end

support = App(title="Support") do s
    body = DOM.div(
        TextBlock("Makie is a big and active project which needs a lot of resources to keep going.
        To make sure, core contributors have enough time to work on Makie, we've to make sure our developers and maintainers are paid for their hard work.
        If you're a regular Makie user, we'd really appreciate if you could support us in one of the following ways:"),
        FlexGrid(
            SupportCard(
                "Sponsoring",
                """
                If you love Makie and want to support us, you can sponsor us on GitHub.
                This is the easiest way to support us, and we're very grateful for every sponsor.
                """
            ),
            SupportCard(
                "Support Contract",
                """
                We're happy to give out support contracts for Makie.
                If you're a power user of Makie at
                """
            ),
            SupportCard(
                "Voluntary License",
                """
                If you're part of an organization that can't just pay for work directly, nor sponsor us, but still wants to support us, we offer a voluntary license for Makie.
                The idea is, to offer a license with an official receipt, that instutations can buy to support us.
                The license is fully voluntary, and doesn't give you any additional rights, but it helps us a lot to secure some basic income.
                """
            ),
            SupportCard(
                "Grants",
                """
                Makie has been funded by grants in the past, and we're always looking for new opportunities.
                If you can help us secure a grant, please contact us.
                We're happy to chat and figure out ways to make it work.
                """
            ),
            SupportCard(
                "Consulting",
                """
                Facing a tough challenge or considering outsourcing a complex visualization?
                We've got you covered. Whether you're determining if Makie suits your project, tackling performance issues, or seeking general assistance, our team is at your service.
                Reach out to us with a concise summary of your project, timeline, and budget, so we can explore the best ways to support your needs.
                """
            ),
        )
    )
    return page(Section(body), "Support")
end


include("src/contact.jl")

function make()
    dir = joinpath(@__DIR__, "docs")
    # rm(dir; recursive=true, force=true); mkdir(dir)
    routes = JSServe.Routes()
    routes["/"] = index
    routes["team"] = team
    routes["contact"] = contact
    routes["support"] = support
    folder = AssetFolder(dir)
    JSServe.export_static(dir, routes; asset_server=folder)
end

make()

# disp = display(app)

# watcher(path) do
#     @async begin
#         @time display(disp, app)
#     end
# end
