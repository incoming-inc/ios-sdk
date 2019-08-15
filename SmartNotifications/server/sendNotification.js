
/**
 * Send a notification using the Firebase admin SDK
 *
 * @param {object} firebase firebase admin SDK instance.
 * @param {string} topic the firebase topic to send to
 * @param {string} title notification title, as visible to the end-user 
 * @param {string} body notification body / message, visible to the end-user
 * @param {string} actionURL deep-link URL to invoke when the user taps the notification e.g. myapp://action/item/24343
 * @param {string} tag an optional string to tag this notification with, will show up in analytics
 * @param {Date} expiry an optional date after which the notification will not be shown to the user
 */ 
function sendNotification(firebase, topic, title, body, actionURL, tag, expiry) {
  var payload = {
    topic: topic,
    data: {
      'handler': 'com.sourse.notification',
      'title':  title,
      'message': body,
      'actionURL': actionURL,
      
    }
	
	if (expiry)	{
		data['expiryDate'] = expiry.toISOString();
	}
	
	if (tag) {
		data['tag'] = tag
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



sendNotification(admin, '/topics/smartNotificationTest', 'Some title', 'some message', 'hostapp://item/12323', 'weeklies-12323', new Date((new Date()).getTime() + (1000 * 3600)))
