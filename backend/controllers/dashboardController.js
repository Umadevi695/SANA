const { db } = require("../config/firebase");

const getDashboardStats = async (req, res) => {
  try {
    const usersSnapshot = await db.collection("users").get();

    const noticesSnapshot = await db.collection("notices").get();

    let totalStudents = 0;
    let totalAdmins = 0;
    let highPriorityNotices = 0;

    usersSnapshot.forEach((doc) => {
      const user = doc.data();

      if (user.role === "student") {
        totalStudents++;
      }

      if (user.role === "admin") {
        totalAdmins++;
      }
    });

    noticesSnapshot.forEach((doc) => {
      const notice = doc.data();

      if (notice.priority === "High") {
        highPriorityNotices++;
      }
    });

    res.status(200).json({
      success: true,
      totalUsers: usersSnapshot.size,
      totalStudents,
      totalAdmins,
      totalNotices: noticesSnapshot.size,
      highPriorityNotices,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

module.exports = {
  getDashboardStats,
};
