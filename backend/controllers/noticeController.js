const { db, admin } = require("../config/firebase");
const { processNotice } = require("../services/pythonService");
const { getMessaging } = require("firebase-admin/messaging");
const fs = require("fs");
const crypto = require("crypto");

// -------------------------------------------------------------

const YEAR_MAP = {
  "1": "1st Year",
  "2": "2nd Year",
  "3": "3rd Year",
  "4": "4th Year",
};

const normalizeYear = (year) => {
  if (!year) return null;
  return YEAR_MAP[year] || year;
};

// -------------------------------------------------------------

const createNotice = async (req, res) => {
  try {
    const { title, category, summary, deadline, priority } = req.body;

    const docRef = await db.collection("notices").add({
      title,
      category,
      summary,
      deadline,
      priority,
      createdAt: new Date(),
    });

    res.status(201).json({
      success: true,
      noticeId: docRef.id,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// -------------------------------------------------------------

const uploadNotice = async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({
        success: false,
        message: "No file uploaded",
      });
    }

    const { title,category,branch, year } = req.body;

    // ---------------------------------------------------------
// Generate SHA-256 hash of uploaded file
// ---------------------------------------------------------

const fileBuffer = fs.readFileSync(req.file.path);

const fileHash = crypto
  .createHash("sha256")
  .update(fileBuffer)
  .digest("hex");

    const branchList = branch
      ? branch.split(",").map((b) => b.trim())
      : ["ALL"];

    const yearList = year
      ? year.split(",").map((y) => y.trim())
      : ["ALL"];

      // ---------------------------------------------------------
// Check duplicate notice
// ---------------------------------------------------------

const duplicateSnapshot = await db
  .collection("notices")
  .where("fileHash", "==", fileHash)
  .limit(1)
  .get();

if (!duplicateSnapshot.empty) {
  return res.status(409).json({
    success: false,
    message: "This notice has already been uploaded.",
  });
}
    const result = await processNotice(req.file.path);

    const docRef = await db.collection("notices").add({
      ...result,
      title:
    title && title.trim() !== ""
      ? title.trim()
      : result.title,

  category:
    category || result.category,

  branch: branchList,
  year: yearList,

  fileName: req.file.filename,
  filePath: req.file.path,
  fileHash: fileHash,
  createdAt: new Date(),
    });

    // ---------------------------------------------------------
    // Send Push Notifications
    // ---------------------------------------------------------

    const usersSnapshot = await db.collection("users").get();

    const tokens = [];

    usersSnapshot.forEach((doc) => {
      const user = doc.data();

      const normalizedYear = normalizeYear(user.year);

      const branchMatch =
        branchList.includes("ALL") ||
        branchList.includes(user.branch);

      const yearMatch =
        yearList.includes("ALL") ||
        yearList.includes(normalizedYear);

      console.log("-----------------------------");
      console.log("Student:", user.name);
      console.log("Branch:", user.branch);
      console.log("Year:", user.year);
      console.log("Normalized Year:", normalizedYear);
      console.log("Branch Match:", branchMatch);
      console.log("Year Match:", yearMatch);
      console.log("Has Token:", !!user.fcmToken);

      if (branchMatch && yearMatch && user.fcmToken) {
        tokens.push(user.fcmToken);
      }
    });

    console.log("==================================");
    console.log("TOKENS FOUND:", tokens.length);
    console.log("==================================");

    if (tokens.length > 0) {
      const response = await getMessaging().sendEachForMulticast({
    tokens,

   notification: {
  title: title && title.trim() !== ""
      ? title.trim()
      : result.title,

  body:
      result.summary ||
      "A new academic notice has been uploaded.",
},

    data: {
        type: "notice",
        noticeId: docRef.id,
    },
});

      console.log(
        `Notification Success: ${response.successCount}`
      );
      console.log(response.responses);

      console.log(
        `Notification Failed: ${response.failureCount}`
      );
    } else {
      console.log("No matching students found.");
    }

    res.status(201).json({
      success: true,
      noticeId: docRef.id,
      notice: result,
    });
  } catch (error) {
    console.error(error);

    res.status(500).json({
      success: false,
      message: error.toString(),
    });
  }
};


// -------------------------------------------------------------

const getAllNotices = async (req, res) => {
  try {
    const snapshot = await db
      .collection("notices")
      .orderBy("createdAt", "desc")
      .get();

    const notices = [];

    snapshot.forEach((doc) => {
      notices.push({
        id: doc.id,
        ...doc.data(),
      });
    });

    res.status(200).json({
      success: true,
      count: notices.length,
      notices,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// -------------------------------------------------------------

const getNoticeById = async (req, res) => {
  try {
    const noticeId = req.params.id;

    const doc = await db
      .collection("notices")
      .doc(noticeId)
      .get();

    if (!doc.exists) {
      return res.status(404).json({
        success: false,
        message: "Notice not found",
      });
    }

    res.status(200).json({
      success: true,
      notice: {
        id: doc.id,
        ...doc.data(),
      },
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// -------------------------------------------------------------

const deleteNotice = async (req, res) => {
  try {
    const noticeId = req.params.id;

    await db.collection("notices").doc(noticeId).delete();

    res.status(200).json({
      success: true,
      message: "Notice deleted successfully",
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// -------------------------------------------------------------

const getStudentNotices = async (req, res) => {
  try {
    const userId = req.user.id;

    const userDoc = await db
      .collection("users")
      .doc(userId)
      .get();

    if (!userDoc.exists) {
      return res.status(404).json({
        success: false,
        message: "User not found",
      });
    }

    const user = userDoc.data();

    const normalizedYear = normalizeYear(user.year);

    const snapshot = await db
      .collection("notices")
      .orderBy("createdAt", "desc")
      .get();

    const notices = [];

    snapshot.forEach((doc) => {
      const notice = doc.data();

      const noticeBranches = Array.isArray(notice.branch)
        ? notice.branch
        : [notice.branch || "ALL"];

      const noticeYears = Array.isArray(notice.year)
        ? notice.year
        : [notice.year || "ALL"];

      const branchMatch =
        noticeBranches.includes("ALL") ||
        noticeBranches.includes(user.branch);

      const yearMatch =
        noticeYears.includes("ALL") ||
        noticeYears.includes(normalizedYear);

      if (branchMatch && yearMatch) {
        notices.push({
          id: doc.id,
          ...notice,
        });
      }
    });

    res.status(200).json({
      success: true,
      count: notices.length,
      notices,
    });
  } catch (error) {
    console.error(error);

    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// -------------------------------------------------------------

const updateNotice = async (req, res) => {
  try {
    const noticeId = req.params.id;

    const {
      title,
      category,
      summary,
      deadline,
      priority,
      branch,
      year,
    } = req.body;

    await db.collection("notices").doc(noticeId).update({
      title,
      category,
      summary,
      deadline,
      priority,
      branch,
      year,
      updatedAt: new Date(),
    });

    res.status(200).json({
      success: true,
      message: "Notice updated successfully",
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// -------------------------------------------------------------

const getReminders = async (req, res) => {
  try {
    const snapshot = await db.collection("notices").get();

    const reminders = [];

    snapshot.forEach((doc) => {
      const notice = doc.data();

      reminders.push({
        id: doc.id,
        title: notice.title,
        category: notice.category,
        deadline: notice.deadline,
        reminders: notice.reminders || [],
      });
    });

    res.status(200).json({
      success: true,
      reminders,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// -------------------------------------------------------------

const searchNotices = async (req, res) => {
  try {
    const { category, keyword } = req.query;

    const snapshot = await db.collection("notices").get();

    let notices = [];

    snapshot.forEach((doc) => {
      notices.push({
        id: doc.id,
        ...doc.data(),
      });
    });

    if (category) {
      notices = notices.filter(
        (notice) =>
          notice.category &&
          notice.category
            .toLowerCase()
            .includes(category.toLowerCase())
      );
    }

    if (keyword) {
      notices = notices.filter(
        (notice) =>
          notice.summary &&
          notice.summary
            .toLowerCase()
            .includes(keyword.toLowerCase())
      );
    }

    res.status(200).json({
      success: true,
      count: notices.length,
      notices,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// -------------------------------------------------------------

module.exports = {
  createNotice,
  uploadNotice,
  getAllNotices,
  getNoticeById,
  deleteNotice,
  getStudentNotices,
  updateNotice,
  getReminders,
  searchNotices,
};