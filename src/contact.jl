function contact()
    form = DOM.form(id="contact-form", class="p-4")

    email_label = DOM.label("Email:", class="text-sm font-medium text-gray-700")
    select_class = "mt-1 w-full py-2 px-3 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
    email_input = DOM.input(id="email", name="email", type="email", class=select_class)

    subject_label = DOM.label("Subject:", class="text-sm font-medium text-gray-700")
    message_textarea = DOM.textarea(id="message_area", name="message", class="h-64 mt-1 w-full py-2 px-3 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm")
    subject_select = DOM.select(
        DOM.option("Consulting", value="consulting"),
        DOM.option("Sponsoring", value="sponsoring"),
        DOM.option("Support Contract", value="contract"),
        DOM.option("Voluntary License", value="license"),
        DOM.option("Grants", value="grants"),
        DOM.option("Feedback", value="feedback"),
        id="subject", name="subject", class=select_class, onchange="on_select"
    )
    message_label = DOM.label("Message:", class="mt-4 text-sm font-medium text-gray-700")
    bclass = "mt-6 py-2 px-4 justify-center text-white font-semibold text-sm rounded-md hover:bg-sky-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 navbar"

    contact_js = ES6Module(asset_path("js", "contact.js"))
    submit_button = DOM.div("Send", onclick="send_email()", class=bclass)
    # Add elements to form
    body = D.FlexCol(
        "We're happy tooo hear from you!
        Please use our form below, or write directly to info at makie.org:",
        form,
        DOM.div(email_label, email_input, class="mb-6"),
        DOM.div(subject_label, subject_select, class="mb-6"),
        DOM.div(message_label, message_textarea, class="mb-6"),
        submit_button,
        class="bg-white shadow-md rounded px-8 pt-6 pb-8 mb-4",
        js"""
            $(contact_js).then((Contact) => {
                Contact.init($message_textarea, $subject_select);
            });
        """
    )

    body2 = DOM.div(DOM.script(src="https://smtpjs.com/v3/smtp.js"), DOM.div(body; class="w-1/2 min-w-fit max-w-5xl"), class="flex flex-col items-center w-full")
    return page(Section(Block(body)), "Contact")
end
