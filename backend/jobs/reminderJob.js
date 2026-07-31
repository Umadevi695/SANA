const cron = require("node-cron");
const { db } = require("../config/firebase");
const { getMessaging } = require("firebase-admin/messaging");

const startReminderJob = () => {
  cron.schedule("* * * * *", async () => {
    try {
      const today = new Date().toISOString().split("T")[0];

      const noticesSnapshot = await db.collection("notices").get();

      for (const noticeDoc of noticesSnapshot.docs) {
        const notice = noticeDoc.data();

        if (notice.reminders && notice.reminders.includes(today)) {
          const usersSnapshot = await db.collection("users").get();

          const tokens = [];

          usersSnapshot.forEach((doc) => {
            const user = doc.data();

            if (user.fcmToken) {
              tokens.push(user.fcmToken);
            }
          });

          if (tokens.length > 0) {
            const response = await getMessaging().sendEachForMulticast({
  tokens,

  notification: {
    title: "⏰ Deadline Reminder",
    body: `${notice.title} deadline is approaching`,
  },

  data: {
    type: "reminder",
    noticeId: noticeDoc.id,
  },
});

            console.log(
              `Reminder sent for ${notice.title} | Success: ${response.successCount} | Failure: ${response.failureCount}`,
            );
          }
        }
      }
    } catch (error) {
      console.error("Reminder Job Error:", error);
    }
  });
};

module.exports = startReminderJob;
