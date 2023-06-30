// from smptjs.com
// Not sure why it's so hard to use them as ES6module, and since its so little code I just gave up debugging the include.
const Email = {
    send: function (a) {
        return new Promise(function (n, e) {
            (a.nocache = Math.floor(1e6 * Math.random() + 1)),
                (a.Action = "Send");
            var t = JSON.stringify(a);
            Email.ajaxPost(
                "https://smtpjs.com/v3/smtpjs.aspx?",
                t,
                function (e) {
                    n(e);
                }
            );
        });
    },
    ajaxPost: function (e, n, t) {
        var a = Email.createCORSRequest("POST", e);
        a.setRequestHeader("Content-type", "application/x-www-form-urlencoded"),
            (a.onload = function () {
                var e = a.responseText;
                null != t && t(e);
            }),
            a.send(n);
    },
    ajax: function (e, n) {
        var t = Email.createCORSRequest("GET", e);
        (t.onload = function () {
            var e = t.responseText;
            null != n && n(e);
        }),
            t.send();
    },
    createCORSRequest: function (e, n) {
        var t = new XMLHttpRequest();
        return (
            "withCredentials" in t
                ? t.open(e, n, !0)
                : "undefined" != typeof XDomainRequest
                ? (t = new XDomainRequest()).open(e, n)
                : (t = null),
            t
        );
    },
};

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

const message_textarea = () => document.querySelector("#message_area");
const subject_select = () => document.querySelector("#subject");
const email_field = () => document.querySelector("#email");

window.on_select = (elem) => {
    const value = elem.srcElement.value;
    const text_node = message_textarea();
    set_default_text(text_node, value);
};

window.send_email = () => {
    const subject = subject_select().value;
    const message = message_textarea().value;
    const from = email_field().value;
    console.log(subject);
    console.log(message);
    console.log(from);
    const email = {
        SecureToken: "61fa11a0-f54c-4477-af6f-3769bb6855b3",
        To: "info@makie.org",
        From: from,
        Subject: subject,
        Body: message,
    };
    Email.send(email).then((response) => {
        if (response == "OK") {
            alert("Email successfully sent!");
        } else {
            alert("Failed to send email: " + response);
        }
    });
}

export function init() {
    // Assuming the URL is something like: http://example.com/?param=value
    // Get the value of the 'param' query parameter from the URL
    const param = new URLSearchParams(window.location.search);
    const selection = param.get("subject") || "consulting";
    // Find the select dropdown element by its ID or any other suitable selector
    // Set the value of the select dropdown to the extracted parameter value
    const select_node = subject_select();
    if (select_node) {
        select_node.value = selection;
        set_default_text(message_textarea(), selection);
    }
}
