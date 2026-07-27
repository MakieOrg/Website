using BonitoSites

using BonitoSites.Dates

blogposts(files...) = joinpath(@__DIR__, "blogposts", files...)

function all_posts()
    folders = filter(isdir, readdir(blogposts(); join=true))
    entries = map(folders) do dir
        dir = normpath(dir)
        path = joinpath(dir, "post.xml")
        return dir => BonitoSites.from_xml(path)
    end
    return sort!(entries; by=x -> x[2].date, rev=true)
end

function add_blogposts!(routes)
    entries = all_posts()
    for (dir, entry) in entries
        route = replace(entry.link, "./" => "/")
        routes[route] = App(title=entry.title) do
            post = BonitoSites.MarkdownPage(dir)
            bsky = isempty(entry.bsky_link) ? nothing : BonitoSites.BlueSkyComment(entry.bsky_link)
            human_date = Dates.format(entry.date, "e, d u Y")
            date_div = DOM.div(human_date; class="post-date", style="color: #666; margin-bottom: 1rem; text-align: center;")
            body = DOM.div(css_asset("markdown-mobile.css"), date_div, post, bsky)
            page(FullWidthBlock(body), "Blog")
        end
    end
    return routes
end

# Own card rendering for SiteEntry: BonitoSites' jsrender shows a
# date-time ("... 12:0:0") and ships inline styles that fight blog_entry CSS.
function blog_entry_card(entry)
    human_date = Dates.format(entry.date, "e, d u Y")
    link = replace(entry.link, "./" => "/")
    img = if isempty(entry.image)
        nothing
    elseif endswith(entry.image, ".mp4")
        DOM.video(src=Asset(entry.image); autoplay=true, loop=true, muted=true)
    else
        DOM.img(src=Asset(entry.image))
    end
    return DOM.a(
        DOM.div(
            DOM.h3(entry.title),
            DOM.h4(entry.description),
            img,
            DOM.div(human_date; class="date");
            class="blog_entry"
        );
        href=Bonito.Link(link),
        class="card w-full blog_card"
    )
end

function blog()
    rss_link = DOM.link(
        rel="alternate",
        type="application/rss+xml",
        title="Makie Blog rss feed",
        href="./rss.xml"
    )
    entries = all_posts()
    cards = [blog_entry_card(entry) for (_, entry) in entries]
    body = DOM.div(
        H1("Blog"),
        rss_link,
        DOM.div(cards...; class="flex flex-col gap-6 w-full");
        class="max-w-3xl mx-auto w-full flex flex-col gap-4"
    )
    return page(Section(body), "Blog")
end

export blog
