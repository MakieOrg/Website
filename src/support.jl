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

support = App(title="Support") do s
    body = Block(
        TextBlock("Makie is a big and active project which needs a lot of resources to keep going.
        To make sure, core contributors have enough time to work on Makie, we've to make sure our developers and maintainers are paid for their hard work.
        If you're a regular Makie user, we'd really appreciate if you could support us in one of the following ways:"),
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
                We're happy to give out support contracts for Makie.
                How it works is, that you pay a fixed amount of money per month, and we'll allocate resources to help out in any way we can.
                """,
                "contract"
            ),
            SponsorCard(
                "Voluntary License",
                """
                If you're part of an organization that can't just pay for work directly, nor sponsor us, but still wants to support us, we offer a voluntary license for Makie.
                The idea is, to offer a license with an official receipt, that instutations can buy to support us.
                The license is fully voluntary, and doesn't give you any additional rights, but it helps us a lot to secure some basic income.
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
