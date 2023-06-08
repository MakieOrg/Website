window.set_default_text = (text_node, value) => {
    switch (value) {
        case "license":
            text_node.value = "I'd like to buy a voluntary license for Makie.";
            break;
        case "consulting":
            text_node.value = `I'd like to hire you for consulting.
My project is:

Expected Timeline:

Expected budget:
`;
            break;
        case "sponsoring":
            text_node.value = "I'd like to sponsor Makie.";
            break;
        case "contract":
            text_node.value =
                "I'd like to buy a support contract for Makie for X hours per month.";
            break;
        case "grants":
            text_node.value = "I'd like to help secure a grant for Makie:";
            break;
        case "feedback":
            text_node.value = "I'd like to give you some feedback:";
            break;
        case "Other":
    }
};

let message_textarea;
let subject_select;

window.on_select = (elem) => {
    const value = elem.srcElement.value;
    const text_node = message_textarea;
    set_default_text(text_node, value);
};

window.send_email = () => {
    const subject = subject_select.value;
    const message = message_textarea.value;
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
};

export function init(textarea, select_node) {
    message_textarea = textarea;
    subject_select = select_node;
    // Assuming the URL is something like: http://example.com/?param=value
    // Get the value of the 'param' query parameter from the URL
    const param = new URLSearchParams(window.location.search);
    const selection = param.get("subject") || "consulting";
    // Find the select dropdown element by its ID or any other suitable selector
    // Set the value of the select dropdown to the extracted parameter value
    if (select_node) {
        select_node.value = selection;
        set_default_text(textarea, selection);
    }
}
