const { db } = require("./config/firebase");

async function testFirestore() {
  try {
    const docRef = await db.collection("test").add({
      message: "Firebase Connected Successfully",
      createdAt: new Date(),
    });

    console.log("Firestore Connected");
    console.log("Document ID:", docRef.id);
  } catch (error) {
    console.error(error);
  }
}

testFirestore();
