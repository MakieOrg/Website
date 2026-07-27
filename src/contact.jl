function contact()
    # Add elements to form
    slack = link("julia slack Makie channel", "https://julialang.org/slack")
    simon_gh = link("Simon", "https://github.com/SimonDanisch")
    julius_gh = link("Julius", "https://github.com/jkrumbiegel")
    frederic_gh = link("Frederic", "https://github.com/ffreyer")

    function social(name, img, url)
        chip = SmallLogo(image=img, link=url)
        return DOM.div(chip, DOM.span(name; class="text-sm text-gray-600"); class="flex items-center gap-2 m-2")
    end

    logos = FlexGrid(
        social("Discord", "logos/discord-mark-blue.svg", "https://discord.gg/2FBjYAT3cY"),
        social("LinkedIn", "logos/linkedin.png", "https://www.linkedin.com/company/makieorg"),
        social("GitHub", "logos/GitHub-Mark-64px.png", "https://github.com/MakieOrg"),
        social("Mastodon", "logos/mastodon.svg", "https://julialang.social/@makie");
        class="justify-center items-center",
    )
    body = DOM.div(
        H1("Contact"),
        DOM.div(
            TextBlock(dom"""
            We're happy to hear from you!

            Write us an email to info@makie.org, join the $(slack),
            or reach the maintainers directly on GitHub: $(simon_gh), $(julius_gh) or $(frederic_gh).

            You can also find us on social media:
            """; width="w-full"),
            logos;
            class="card p-6 sm:p-8 w-full flex flex-col gap-4"
        );
        class="max-w-2xl mx-auto w-full flex flex-col gap-6"
    )
    return page(Section(body), "Contact")
end
