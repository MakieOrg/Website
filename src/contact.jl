
contact = App(title="Contact") do
    form = DOM.form(id="contact-form", class="p-4")
    subject_label = DOM.label("Subject:", class="text-sm font-medium text-gray-700")
    select_class = "mt-1 w-full py-2 px-3 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
    consulting_filler = """
    I'd like to hire you for consulting.
    My project is:

    Expected Timeline:

    Expected budget:
    """
    message_textarea = DOM.textarea(consulting_filler, id="message", name="message", class="h-64 mt-1 w-full py-2 px-3 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm")
    on_select = js"""
    function on_select(elem) {
        const value = elem.srcElement.value;
        const text_node = $(message_textarea);
        switch (value) {
            case "License":
                text_node.value = "I'd like to buy a voluntary license for Makie.";
                break;
            case "Consulting":
                text_node.value = ```
                I'd like to hire you for consulting.
                My project is:

                Expected Timeline:

                Expected budget:
                ```;
                break;
            case "Sponsoring":
                text_node.value = "I'd like to sponsor Makie.";
                break;
            case "Support Contract":
                text_node.value = "I'd like to buy a support contract for Makie for X hours per month.";
                break;
            case "Grants":
                text_node.value = "I'd like to help secure a grant for Makie:";
                break;
            case "Feedback":
                text_node.value = "I'd like to give you some feedback:";
                break;
            case "Other":
        }
    }
    """

    subject_select = DOM.select(
        DOM.option("Consulting", value="Consulting"),
        DOM.option("Sponsoring", value="Sponsoring"),
        DOM.option("Support Contract", value="Support Contract"),
        DOM.option("License", value="License"),
        DOM.option("Grants", value="Grants"),
        DOM.option("Feedback", value="Feedback"),
        id="subject", name="subject", class=select_class, onchange=on_select
    )
    message_label = DOM.label("Message:", class="mt-4 text-sm font-medium text-gray-700")
    bclass = class = "mt-6 inline-flex justify-center py-2 px-4 text-sm rounded-md text-white navbar hover:bg-sky-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"

    on_send = js"""
        function sendEmail() {
            const subject = $(subject_select).value;
            const message = $(message_textarea).value;
            console.log(subject);
            console.log(message);
            /*
            Email.send({
                SecureToken: 'YourSMTPJSToken',
                To: 'info@makie.org',
                From: 'yourEmail@example.com',
                Subject: subject,
                Body: message
            }).then(response => {
                if (response == 'OK') {
                    alert('Email successfully sent!');
                } else {
                    alert('Failed to send email: ' + response);
                }
            });
            */
        }
    """

    submit_button = DOM.input(type="button", value="Send", onclick=on_send, class=bclass)
    # Add elements to form
    body = D.FlexCol(
        form,
        DOM.div(subject_label, subject_select, class="mb-6"),
        DOM.div(message_label, message_textarea, class="mb-6"),
        submit_button,
        class="bg-white shadow-md rounded px-8 pt-6 pb-8 mb-4"
    )
    body2 = DOM.div(DOM.div(body; class="w-1/2 min-w-fit max-w-5xl"), class="flex flex-col items-center w-full")
    return page(Section(body), "Contact")
end
