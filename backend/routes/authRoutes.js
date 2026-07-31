const express = require("express");

const router = express.Router();

const {
  register,
  login,
  saveFcmToken,
} = require("../controllers/authController");

router.post("/register", register);
router.post("/login", login);
router.post("/save-fcm-token", saveFcmToken);

module.exports = router;
