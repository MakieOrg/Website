struct SponsorCard
    title
    content
    value
end

function JSServe.jsrender(s::Session, card::SponsorCard)
    url = JSServe.Link("/contact?subject=" * card.value)
    url_val = JSServe.url(s, url)
    onclick = js"()=> location.href = $(url_val)"
    c = DOM.div(D.FlexCol(H2(card.title), DOM.span(card.content; class="px-2")); onclick=onclick)
    return JSServe.jsrender(s, DOM.div(c; class="$(CARD_STYLE) m-2 p-1 hover:bg-gray-300 grow w-full lg:w-1/3"))
end

function support()
    body = DOM.div(
        TextBlock("Makie is a large and vibrant project which relies heavily on dedicated developer effort.
        To ensure our core contributors can fully focus on advancing Makie, it's crucial to support our hardworking developers and maintainers.
        As a regular Makie user, your contribution in any of the following ways would be greatly appreciated:"),
        FlexGrid(
            SponsorCard(
                "Sponsoring",
                dom"""
                If you love Makie and want to support us, you can sponsor us on GitHub.
                This is the easiest way to support us, and we're very grateful for every sponsor.
                """,
                "sponsoring"
            ),
            SponsorCard(
                "Support Contract",
                """
                We are happy to give out support contracts for Makie.
                You contribute a fixed monthly amount, and in return, we will dedicate resources to assist you in any way possible.
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
                """
                Facing a tough challenge or considering outsourcing a complex visualization?
                We've got you covered. Whether you're determining if Makie suits your project, tackling performance issues, or seeking general assistance, our team is at your service.
                Reach out to us with a concise summary of your project, timeline, and budget, so we can explore the best ways to support your needs.
                """,
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
            )
        )
    )
    return page(Section(body), "Support")
end
