
function md2html(s, file)
    source = read(file, String)
    return Bonito.string_to_markdown(s, source; eval_julia_code=Main)
end

camelcase_break_suggest(s::String) = DOM.span_unesc(
    join(
        split(s, r"(?<=[a-z])(?=[A-Z])"),
        "&ZeroWidthSpace;"
    )
)

Bonito.jsrender(s::Session, card::Vector) = Bonito.jsrender(s, DOM.div(card...; class="flex flex-wrap"))

const CARD_STYLE = "rounded-md p-2 px-3 shadow bg-white"

H1(x) = DOM.h1(x; class="text-xl font-black text-left my-4")
H2(x) = DOM.h2(x; class="text-lg font-bold text-left my-3")
H2Focus(x) = DOM.h2(x; class="text-lg font-bold text-left")
H3(x) = DOM.h3(x; class="text-sm font-semibold text-left")
link(name, href; class="visited:text-purple-600 text-blue-600", style="") = DOM.a(name; href=href, target="_blank", class=class, style=style)

FlexGrid(elems...; class="", kwargs...) = DOM.div(elems...; class=join(["flex flex-wrap", class], " "), kwargs...)
Grid(elems...; class="", kwargs...) = DOM.div(elems...; class=join(["grid ", class], " "), kwargs...)
TextBlock(text; width="max-w-prose") = DOM.div(text; class="text-base $width")
Block(elems...) = DOM.div(elems...; class="p-4 max-w-5xl")
Section(content...; bg="") = DOM.div(
    Block(content...),
    class="$bg flex flex-col items-center w-full"
)
FullWidthText(text; class="") = DOM.div(text, class="w-full text-justify $class")
function Showcase(; title, image, href=nothing)
    img = render_media(img_asset(image))
    content = DOM.div(H3(title), img; class="flex flex-col gap-2")
    if isnothing(href)
        return content
    else
        return link(content, href; class="")
    end
end

function FocusBlock(description; image="", link="", height="400px", rev=false)
    img = image isa String ? render_media(img_asset(image); class=CARD_STYLE) : image
    block = [
        TextBlock(description; width="w-full text-justify md:basis-3/5"),
        DOM.div(Website.link(img, link); class="w-full md:basis-2/5")
    ]
    return DOM.div(block...; class="flex gap-6 items-center flex-col $(rev ? "sm:flex-row-reverse" : "sm:flex-row")")
end
Spacer(size) = DOM.div(class = "w-full my-$size")

Base.@kwdef struct Logo
    image::String=""
    link::String=""
    class::String = "w-1/2 sm:w-1/3 lg:w-1/5 lg:p-8 p-6 flex justify-center"
end

SmallLogo(; kw...) = Logo(; class="rounded-md p-2 m-2 shadow bg-white w-8", kw...)

function render_media(asset::Asset; class="", style="")
    if asset.media_type == :mp4
        return DOM.video(DOM.source(src=asset, type="video/mp4"); muted=true, controls=false, autoplay=true, loop=true, class=class, style=style)
    else
        return DOM.img(src=asset; class=class, style=style)
    end
end

function Bonito.jsrender(s::Session, logo::Logo)
    img = DOM.img(src=img_asset(logo.image), class="w-full")
    return Bonito.jsrender(s, DOM.div(
        link(img, logo.link; class="w-full"),
        class=logo.class)
    )
end

Base.@kwdef struct DetailedCard
    title::String = ""
    image::String = ""
    link::String = ""
    imclass::String = "w-96"
    details::Any = nothing
end

function Bonito.jsrender(s::Session, card::DetailedCard)
    img = render_media(img_asset(card.image); class="image w-full")
    details = if card.details isa Markdown.MD
        Bonito.md_html(s, card.details.content[1])
    else
        card.details
    end
    content = DOM.div(
        class="flex flex-col mt-1 p-2 md:p-4 gap-1",
        DOM.div(camelcase_break_suggest(card.title), class="text-xs lg:text-sm font-semibold text-center"),
        DOM.div(img, DOM.div(details, class="overlay text-xs lg:text-base"), class="container"),
    )
    card_div = DOM.div(
        class="rounded-md shadow bg-white flex justify-center $(card.imclass)",
        link(content, card.link; class="")
    )

    return Bonito.jsrender(s, card_div)
end

function QuoteBlock(author, authorlink, quote_text, quote_link)
    return DOM.div(
        class="text-justify text-gray-600 w-full bg-gray-200 px-5 py-4 rounded-md hover:bg-gray-300",
        DOM.span(
            DOM.a(DOM.span("„" * strip(quote_text) * "“", class="text-left italic"); href=quote_link, target="_blank"),
            link("(" * author * ")", authorlink),
            class="text-sm lg:text-base",
        ),
    )
end

function Navigation(highlighted="")
    function item(name, href; target="")
        highlight = highlighted == name ? " navbar-highlight" : ""
        class = "text-white cursor-pointer py-1 px-2 hover:opacity-50 $highlight"
        return DOM.a(DOM.div(name, class=class); href=Bonito.Link(href), target=target)
    end
    github = img_asset("logos/GitHub-Mark-Light-64px.png")
    img_style = "height: 1.2rem; display: inline-block; vertical-align: text-bottom;"
    return DOM.div(
        class="flex navbar justify-center", # TailwindCSS classes
        DOM.div(
            class="flex max-w-5xl w-full md:px-4 flex-wrap",
            item("Home", "/"),
            item("Team", "/team"),
            item("Support", "/support"),
            item("Contact", "/contact"),
            item("Docs", "http://docs.makie.org"; target="_blank"),
            item(DOM.img(src=github, style=img_style), "https://github.com/MakieOrg/Makie.jl"; target="_blank")
        )
    )
end

function tracking()
    DOM.div(
        DOM.script(src="https://api.makie.org/latest.js"; async=true, defer=true),
        DOM.noscript(DOM.img(src="https://api.makie.org/noscript.gif"; alt="", referrerpolicy="no-referrer-when-downgrade"))
    )
end

function page(body, highlighted)
    header = DOM.img(src=img_asset("bannermesh_gradient.png"); style="width: 100%")
    return DOM.html(
        DOM.head(
            DOM.meta(name="viewport", content="width=device-width, initial-scale=1.0"),
            DOM.meta(charset="utf-8"),
            css_asset("site.css"),
            Bonito.TailwindCSS,
        ),
        DOM.body(
            DOM.div(

                DOM.link(href=img_asset("icon_transparent.png"), rel="icon", type="image/png"),
                header,
                Navigation(highlighted),
                body,
                tracking())
        )
    )
end
