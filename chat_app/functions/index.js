const functions = require("firebase-functions");
const admin = require("firebase-admin");
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//

admin.initializeApp();

exports.myFunction = functions.firestore
  .document("chats/{chatId}/{messages}/{messagesId}")
  .onWrite((snapshot, context) => {
    console.log(snapshot)
    return 
    // admin.messaging().sendToTopic("chat", {
    //   notification: {
    //     title: snapshot.data().username,
    //     body: snapshot.data().text,
    //     clickAction: "FLUTTER_NOTIFICATION_CLICK",
    //   },
    // });
  });
