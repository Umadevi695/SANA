const express = require("express");

const router = express.Router();

const {
  testNotification,
  getNotifications,
} = require("../controllers/notificationController");

router.post("/test", testNotification);
router.get("/all", getNotifications);

module.exports = router;
