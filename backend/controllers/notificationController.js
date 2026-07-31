const { sendNotification } = require("../services/notificationService");
const { getMessaging } = require("firebase-admin/messaging");
const { db } = require("../config/firebase");

const testNotification = async (req, res) => {
  try {
    const { token } = req.body;

    await sendNotification(
      token,
      "Test Notification",
      "FCM is working successfully",
    );

    res.status(200).json({
      success: true,
      message: "Notification sent",
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

const createNotification = async (title, message, noticeId) => {
  await db.collection("notifications").add({
    title,
    message,
    noticeId,
    createdAt: new Date(),
  });
};

const getNotifications = async (req, res) => {
  try {
    const snapshot = await db
      .collection("notifications")
      .orderBy("createdAt", "desc")
      .get();

    const notifications = [];

    snapshot.forEach((doc) => {
      notifications.push({
        id: doc.id,
        ...doc.data(),
      });
    });

    res.status(200).json({
      success: true,
      notifications,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

module.exports = {
  testNotification,
  getNotifications,
  createNotification,
};
