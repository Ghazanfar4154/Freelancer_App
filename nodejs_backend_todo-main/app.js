const express = require("express");
const bodyParser = require("body-parser");
const UserRoute = require("./routes/user.routes");
const ProjectRoute = require("./routes/project.routes");
const ChatRoute = require("./routes/chat.routes");
const NotificationRoute = require("./routes/notification.routes"); // Import notification routes

const app = express();

// Increase body size limit
app.use(bodyParser.json({ limit: '50mb' }));
app.use(bodyParser.urlencoded({ limit: '50mb', extended: true }));

app.use("/", UserRoute);
app.use("/projects", ProjectRoute);
app.use("/chat", ChatRoute);
app.use("/notifications", NotificationRoute); // Use notification routes

module.exports = app;
