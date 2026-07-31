const express = require("express");
const cors = require("cors");
const path = require("path");
const startReminderJob = require("./jobs/reminderJob");
require("dotenv").config();

const noticeRoutes = require("./routes/noticeRoutes");
const authRoutes = require("./routes/authRoutes");
const dashboardRoutes = require("./routes/dashboardRoutes");
const notificationRoutes = require("./routes/notificationRoutes");

const app = express();

app.use(cors());
app.use(express.json());

// Make uploads folder public
app.use("/uploads", express.static(path.join(__dirname, "uploads")));

app.use("/api/notices", noticeRoutes);
app.use("/api/auth", authRoutes);
app.use("/api/dashboard", dashboardRoutes);
app.use("/api/notifications", notificationRoutes);

app.get("/", (req, res) => {
  res.send("Smart Academic Notice Analyzer Backend Running");
});

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
  startReminderJob();
});
