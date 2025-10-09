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

function blog()
    rss_link = DOM.link(
        rel="alternate",
        type="application/rss+xml",
        title="Makie Blog rss feed",
        href="./rss.xml"
    )
    entries = all_posts()
    site_entries = map(entries) do (_, entry)
        style = """
        div.blog_entry h3 {
            font-weight:700;
            font-size:1.125rem;
            line-height:1.75rem;
        }
        """
        DOM.div(entry, class="$CARD_STYLE blog_entry max-w-prose", style=style)
    end
    body = DOM.div(rss_link, Bonito.Col(site_entries...))
    return page(Section(body), "Blog")
end

export blog
