const { admin } = require("../config/firebase");

const sendNotification = async (fcmToken, title, body) => {
  const message = {
    notification: {
      title,
      body,
    },
    token: fcmToken,
  };

  try {
    const response = await admin.messaging().send(message);

    console.log("Notification sent:", response);

    return response;
  } catch (error) {
    console.error("Notification error:", error);

    throw error;
  }
};

module.exports = {
  sendNotification,
};
