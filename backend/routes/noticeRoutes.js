const express = require("express");
const router = express.Router();

const upload = require("../middleware/uploadMiddleware");
const { protect } = require("../middleware/authMiddleware");
const { adminOnly } = require("../middleware/adminMiddleware");

const {
  createNotice,
  uploadNotice,
  getAllNotices,
  getNoticeById,
  deleteNotice,
  getStudentNotices,
  updateNotice,
  getReminders,
  searchNotices,
} = require("../controllers/noticeController");

router.post(
  "/upload",
  protect,
  adminOnly,
  upload.single("noticeFile"),
  uploadNotice,
);
router.get("/", protect, adminOnly, getAllNotices);
router.get("/student/notices", protect, getStudentNotices);
router.get("/reminders/all", protect, getReminders);
router.get("/search", protect, searchNotices);
router.get("/:id", getNoticeById);
router.put("/:id", protect, adminOnly, updateNotice);
router.delete("/:id", protect, adminOnly, deleteNotice);
module.exports = router;
