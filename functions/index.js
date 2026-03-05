const functions = require("firebase-functions");
const admin = require("firebase-admin");
const {GoogleGenerativeAI} = require("@google/generative-ai");

admin.initializeApp();

const genAI = new GoogleGenerativeAI("AIzaSyB2gPBNWddJP5jua5MTsyqe7kABUZhWX14");

exports.askProductAI = functions.https.onCall(async (data, context) => {
  const {productId, userQuestion, role} = data;

  // 1️⃣ Get product from Firestore
  const productDoc = await admin.firestore()
      .collection("products")
      .doc(productId)
      .get();

  if (!productDoc.exists) {
    throw new functions.https.HttpsError("not-found", "Product not found");
  }

  const product = productDoc.data();

  // 2️⃣ Role-based instruction
  let roleInstruction = "";

  if (role === "customer") {
    roleInstruction = "Reply professionally as an Ayurvedic product assistant helping a customer.";
  } else if (role === "seller") {
    roleInstruction = "Reply as a seller dashboard assistant providing detailed business information.";
  } else {
    roleInstruction = "Reply professionally.";
  }

  // 3️⃣ Structured prompt
  const prompt = `
  ${roleInstruction}

  Product Data:
  Name: ${product.name}
  Ingredients: ${product.ingredients}
  Benefits: ${product.benefits}
  Expiry: ${product.expiry}
  AYUSH License: ${product.license}
  Shipping Info: ${product.shippingInfo}

  User Question:
  ${userQuestion}

  Give a clear, structured response.
  `;

  const model = genAI.getGenerativeModel({model: "gemini-1.5-flash"});

  const result = await model.generateContent(prompt);
  const response = result.response.text();

  return {reply: response};
});
