module.exports = async (require) => {
    const path = require("path");
    const killTheNewsletter = require(".").default;

    const { webApplication, emailApplication } = killTheNewsletter(
        path.join(__dirname, "data")
    );

    webApplication.set("url", "https://newsletter.tjpalanca.com");
    webApplication.set("email", "smtp://newsletter.tjpalanca.com");
    webApplication.set("administrator", "mailto:newsletter@tjpalanca.com");
    webApplication.listen(8080, () => {
        console.log("Web application started");
    });

    emailApplication.listen(2525, () => {
        console.log("Email server started");
    });
};
