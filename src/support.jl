struct SponsorCard
    title
    content
    value
end

function Bonito.jsrender(s::Session, card::SponsorCard)
    url_val = startswith(card.value, "https") ? card.value : Bonito.url(s, Bonito.Link("/contact"))
    onclick = js"()=> location.href = $(url_val)"
    c = DOM.div(
        DOM.h3(card.title; class="text-lg font-semibold text-black"),
        DOM.div(card.content; class="text-gray-600 text-left");
        class="flex flex-col gap-2"
    )
    return Bonito.jsrender(s, DOM.div(c; class="card p-6 cursor-pointer", onclick=onclick))
end

function support()
    body = DOM.div(
        H1("Support Makie"),
        TextBlock("Makie is a large and vibrant project which relies heavily on dedicated developer effort.
        To ensure our core contributors can fully focus on advancing Makie, it's crucial to support our hardworking developers and maintainers.
        As a regular Makie user, your contribution in any of the following ways would be greatly appreciated:"; width="w-full"),
        Spacer(4),
        Grid(
            SponsorCard(
                "Sponsoring",
                dom"""
                If you love Makie and want to support us, you can sponsor us on GitHub.
                This is the easiest way to support us, and we're very grateful for every sponsor.
                """,
                "https://github.com/sponsors/MakieOrg"
            ),
            SponsorCard(
                "Support Contract",
                """
                We are happy to give out support contracts for Makie.
                You contribute a fixed monthly amount, and in return we prioritize your questions and issues, and make time to help you directly.
                Please contact us to discuss any details.
                """,
                "contract"
            ),
            SponsorCard(
                "Voluntary License",
                """
                If you represent an organization that is unable to provide direct payment or sponsorship but still wish to support us,
                we have an alternative option: a voluntary license for Makie.
                The concept behind this license is to provide institutions with an official receipt upon purchase, categorizing it as a software purchase.
                While the license does not grant any additional rights, it can be paid from an institutions software budget and helps us to improve Makie.
                """,
                "license"
            ),
            SponsorCard(
                "Consulting",
                DOM.div(
                    DOM.p("""Facing a tough visualization challenge, or considering outsourcing complex work? \
                    Several of the maintainers take on consulting and contract work independently. \
                    Reach out to whoever fits your project:"""),
                    DOM.ul(
                        DOM.li(DOM.b("Simon"), ": GPU, geometry, web dashboards and overall architecture"),
                        DOM.li(DOM.b("Julius"), ": layout, themes, statistical plotting (AlgebraOfGraphics) and 2D / vector output"),
                        DOM.li(DOM.b("Frederic"), ": rendering backends, OpenGL shaders and numerical math");
                        class="list-disc text-left mt-2", style="padding-left: 1.25rem"
                    )
                ),
                "consulting"
            ),
            SponsorCard(
                "Grants",
                """
                Makie has been funded by grants in the past, and we're always looking for new opportunities.
                If you can help us secure a grant, please contact us.
                We're happy to chat and figure out ways to make it work.
                """,
                "grants"
            );
            class="gap-4 grid-cols-1 md:grid-cols-2 lg:grid-cols-3 items-start"
        )
    )
    return page(Section(body), "Support")
end
