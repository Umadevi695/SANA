const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const { db } = require("../config/firebase");

const register = async (req, res) => {
  try {
    const { name, email, password, role, branch, year } = req.body;

    const hashedPassword = await bcrypt.hash(password, 10);

    const docRef = await db.collection("users").add({
      name,
      email,
      password: hashedPassword,
      role,
      branch: branch || null,
      year: year || null,
      createdAt: new Date(),
    });

    res.status(201).json({
      success: true,
      userId: docRef.id,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

const login = async (req, res) => {
  try {
    const { email, password } = req.body;

    const snapshot = await db
      .collection("users")
      .where("email", "==", email)
      .get();

    if (snapshot.empty) {
      return res.status(404).json({
        success: false,
        message: "User not found",
      });
    }

    let user;

    snapshot.forEach((doc) => {
      user = {
        id: doc.id,
        ...doc.data(),
      };
    });

    const isMatch = await bcrypt.compare(password, user.password);

    if (!isMatch) {
      return res.status(401).json({
        success: false,
        message: "Invalid password",
      });
    }

    const token = jwt.sign(
      {
        id: user.id,
        role: user.role,
      },
      process.env.JWT_SECRET,
      {
        expiresIn: "7d",
      },
    );

    res.status(200).json({
      success: true,
      token,
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        role: user.role,
        branch: user.branch,
        year: user.year,
      },
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

const saveFcmToken = async (req, res) => {
  try {
    const { userId, fcmToken } = req.body;

    await db.collection("users").doc(userId).update({
      fcmToken,
    });

    res.json({
      success: true,
      message: "FCM token saved",
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

module.exports = { register, login, saveFcmToken };
