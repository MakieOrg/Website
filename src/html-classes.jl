using Dates

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

const CARD_STYLE = "card p-4"

# Type scale: real hierarchy instead of everything at 18px
H1(x) = DOM.h1(x; class="text-3xl font-bold text-left tracking-tight text-black my-4")
H2(x) = DOM.h2(x; class="text-2xl font-bold text-left tracking-tight text-black my-3")
H2Focus(x) = DOM.h2(x; class="text-2xl font-bold text-left tracking-tight text-black")
H3(x) = DOM.h3(x; class="text-sm font-semibold text-left")
link(name, href; class="text-blue-600 hover:underline", style="") = DOM.a(name; href=href, target="_blank", class=class, style=style)

FlexGrid(elems...; class="", kwargs...) = DOM.div(elems...; class=join(["flex flex-wrap", class], " "), kwargs...)
Grid(elems...; class="", kwargs...) = DOM.div(elems...; class=join(["grid ", class], " "), kwargs...)
TextBlock(text; width="max-w-prose") = DOM.div(text; class="text-base text-left $width")
Block(elems...) = DOM.div(elems...; class="px-4 py-6 max-w-6xl w-full mx-auto")
FullWidthBlock(elems...) = DOM.div(elems...; class="p-4 w-full")
Section(content...; bg="") = DOM.div(
    Block(content...),
    class="$bg flex flex-col items-center w-full"
)
FullWidthText(text; class="") = DOM.div(text, class="w-full text-left text-lg $class")

function Showcase(; title, image, href=nothing)
    img = render_media(img_asset(image); class="w-full rounded-xl border shadow-sm")
    content = DOM.div(
        img,
        DOM.div(title; class="text-sm font-semibold text-gray-600 mt-2 text-center");
        class="flex flex-col"
    )
    if isnothing(href)
        return content
    else
        return link(content, href; class="")
    end
end

function FocusBlock(description; image="", link="", height="400px", rev=false)
    img = image isa String ? render_media(img_asset(image); class="w-full rounded-xl border shadow-sm") : image
    block = [
        TextBlock(description; width="w-full md:basis-3/5"),
        DOM.div(Website.link(img, link); class="w-full md:basis-2/5")
    ]
    return DOM.div(block...; class="flex gap-8 items-center flex-col $(rev ? "sm:flex-row-reverse" : "sm:flex-row")")
end
Spacer(size) = DOM.div(class = "w-full my-$size")

Base.@kwdef struct Logo
    image::String=""
    link::String=""
    class::String = "w-1/2 sm:w-1/3 lg:w-1/5 p-4 flex justify-center items-center"
end

SmallLogo(; kw...) = Logo(; class="rounded-full border p-2 m-2 shadow-sm bg-white w-10 flex justify-center", kw...)

function render_media(asset::Asset; class="", style="")
    if asset.media_type == :mp4
        return DOM.video(DOM.source(src=asset, type="video/mp4"); muted=true, controls=false, autoplay=true, loop=true, class=class, style=style)
    else
        return DOM.img(src=asset; class=class, style=style)
    end
end

function Bonito.jsrender(s::Session, logo::Logo)
    img = DOM.img(src=img_asset(logo.image), class="w-full logo-img")
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
    img = render_media(img_asset(card.image); class="image w-full rounded-xl")
    details = if card.details isa Markdown.MD
        Bonito.md_html(card.details.content[1])
    else
        card.details
    end
    content = DOM.div(
        class="flex flex-col gap-1",
        DOM.div(img, DOM.div(details, class="overlay text-sm"), class="container"),
        DOM.div(camelcase_break_suggest(card.title), class="text-sm font-semibold text-center py-2"),
    )
    card_div = DOM.div(
        class="card flex justify-center p-3 $(card.imclass)",
        link(content, card.link; class="")
    )

    return Bonito.jsrender(s, card_div)
end

function QuoteBlock(author, authorlink, quote_text, quote_link)
    return DOM.div(
        class="text-left w-full bg-gray-50 border px-5 py-4 rounded-xl quote-card",
        DOM.span(
            DOM.a(DOM.span("„" * strip(quote_text) * "“", class="text-left italic text-gray-600"); href=quote_link, target="_blank"),
            link("(" * author * ")", authorlink; class="text-gray-500 hover:underline"),
            class="text-sm lg:text-base",
        ),
    )
end

function Navigation(highlighted="")
    function item(name, href; target="")
        highlight = highlighted == name ? " navbar-highlight" : ""
        class = "cursor-pointer py-1 px-3$highlight"
        return DOM.a(name; href=Bonito.Link(href), target=target, class=class)
    end
    icon = img_asset("icon_transparent.png")
    brand = DOM.a(
        DOM.div(
            DOM.img(src=icon; style="height: 1.75rem; width: auto; display: inline-block;"),
            DOM.span("Makie"; class="font-bold text-lg text-black tracking-tight");
            class="flex items-center gap-2"
        );
        href=Bonito.Link("/")
    )
    entries = [
        ("Home", "/", ""),
        ("Maintainers", "/team", ""),
        ("Support", "/support", ""),
        ("Contact", "/contact", ""),
        ("Blog", "/blog", ""),
        ("Docs", "http://docs.makie.org", "_blank"),
        ("GitHub", "https://github.com/MakieOrg/Makie.jl", "_blank"),
    ]
    navitems = [item(n, h; target=t) for (n, h, t) in entries]
    return DOM.div(
        class="navbar flex justify-center",
        DOM.div(
            class="flex max-w-6xl w-full px-4 py-2 items-center",
            brand,
            DOM.div(class="grow"),
            DOM.div(navitems...; class="nav-desktop items-center gap-1"),
            DOM.details(
                DOM.summary("☰"),
                DOM.div(navitems...; class="nav-menu");
                class="nav-mobile"
            )
        )
    )
end

function tracking()
    DOM.div(
        DOM.script(src="https://api.makie.org/latest.js"; async=true, defer=true),
        DOM.noscript(DOM.img(src="https://api.makie.org/noscript.gif"; alt="", referrerpolicy="no-referrer-when-downgrade"))
    )
end

function footer()
    year = Dates.year(Dates.today())
    flink(name, href; kw...) = DOM.a(name; href=href, class="text-gray-500 hover:underline", kw...)
    return DOM.div(
        class="w-full flex justify-center mt-14",
        style="border-top: 1px solid var(--border)",
        DOM.div(
            class="max-w-6xl w-full px-4 py-8 flex flex-wrap gap-4 items-center text-sm",
            DOM.span("© $year MakieOrg"; class="text-gray-500"),
            DOM.div(class="grow"),
            flink("GitHub", "https://github.com/MakieOrg/Makie.jl"; target="_blank"),
            flink("Docs", "https://docs.makie.org"; target="_blank"),
            flink("Blog", Bonito.Link("/blog")),
        )
    )
end

function page(body, highlighted)
    return DOM.html(
        DOM.head(
            DOM.meta(name="viewport", content="width=device-width, initial-scale=1.0"),
            DOM.meta(charset="utf-8"),
            DOM.link(href=img_asset("icon_transparent.png"), rel="icon", type="image/png"),
            website_styles(),
        ),
        DOM.body(
            Navigation(highlighted),
            body,
            footer(),
            tracking()
        )
    )
end
