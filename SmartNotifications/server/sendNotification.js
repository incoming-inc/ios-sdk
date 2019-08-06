
/// Example function to send a Sourse smart notification using the Firebase admin SDK for javascript
function sendNotification(firebase, topic, title, body, actionURL, tag) {
  var payload = {
    topic: topic,
    data: {
      'handler': 'com.sourse.notification',
      'title':  title,
      'message': body,
      'actionURL': actionURL,
      'tag': tag
    }
  };

  firebase.messaging().send(payload)
  .then(function(response) {
    console.log('Successfully sent message:', response);
  })
  .catch(function(error) {
    console.log('Error sending message:', error);
  });
}


// initialize the firebase admin SDK
var admin = require('firebase-admin');

// replace with your firebase service account 
var serviceAccount = require("./sourse-smartnotif-demo-firebase-adminsdk-462gm-a960a787ad.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

sendNotification(admin, '/topics/smartNotificationTest', 'Some title', 'some message', 'hostapp://item/12323', 'weeklies-12323')
