function contact()
    # Add elements to form
    slack = link("julia slack Makie channel", "https://julialang.org/slack")
    row(name, img, link) = D.FlexGrid(H3(name), SmallLogo(image=img, link=link); class="justify-center items-center -m-2 md:-m-4 lg:-m-8 p-10")

    logos = D.FlexGrid(
        row("Discord: ", "logos/discord-mark-blue.svg", "https://discord.gg/2FBjYAT3cY"),
        row("Linkedin:", "logos/linkedin.png", "https://www.linkedin.com/company/makieorg"),
        row("Github:", "logos/GitHub-Mark-64px.png", "https://github.com/MakieOrg"),
        row("Mastodon:", "logos/mastodon.svg", "https://julialang.social/@makie"),
        class="justify-center items-center -m-2 md:-m-4 lg:-m-8 p-8",
    )
    body = DOM.div(
        TextBlock(dom"
        We're happy to hear from you! $(DOM.br())

        Write us an email to info@makie.org, join the $(slack), $(DOM.br())

        or write us on any of our social media channels: $(DOM.br())"),
        logos; class=CARD_STYLE
    )
    return page(Section(body), "Contact")
end
