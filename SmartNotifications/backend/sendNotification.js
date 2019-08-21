
/**
 * Send a notification using the Firebase admin SDK. Use condition to send this notification
 * only to client which have integrated the sourse ISDK. 
 *
 * @param {object} firebase firebase admin SDK instance.
 * @param {string} topic the firebase topic to send to
 * @param {string} title notification title, as visible to the end-user 
 * @param {string} body notification body / message, visible to the end-user
 * @param {string} actionURL deep-link URL to invoke when the user taps the notification e.g. myapp://action/item/24343
 * @param {string} tag an optional string to tag this notification with, will show up in analytics
 * @param {Date} expiry an optional date after which the notification will not be shown to the user
 * @oaram {bool} isSmart true if the notification is a smart notification, false if it's not, and should be shown immediately
 * @returns Promise
 */ 
async function sendSourseSmartNotification(firebase, topic, title, body, actionURL, tag, expiry, isSmart) {
  var payload = {
    condition: `'${topic}' in topics && 'sourse_sdk_integrated' in topics`,
    data: {
      'handler': 'com.sourse.notification',
      'title':  title,
      'message': body,
      'actionURL': actionURL,
    }
  }
	
	if (expiry != null)	{
		payload.data['expiryDate'] = expiry.toISOString();
	}
	
	if (tag != null) {
		payload.data['tag'] = tag;
  }

  if (isSmart != null) {
    payload.data['isSmartNotification'] = isSmart ? '1' : '0';
  }

  return new Promise((resolve, reject) => {
    firebase.messaging().send(payload).then((response) => {
      console.log('Successfully sent message:', response);
      return resolve();
    }).catch((error) => {
      const newError =  new Error("Error sending firebase notification with payload " + JSON.stringify(payload) + ": " + error);
      return reject(newError);
    })
  });

}


/**
 * Send a notification using the Firebase admin SDK. Use condition to send this notification
 * only to client which have NOT integrated the sourse ISDK. 
 *
 * @param {object} firebase firebase admin SDK instance.
 * @param {string} topic the firebase topic to send to
 * @param {string} title notification title, as visible to the end-user 
 * @param {string} body notification body / message, visible to the end-user
 * @returns Promise
 */ 
async function sendStandardNotification(firebase, topic, title, body) {
  var payload = {
    condition: `'${topic}' in topics && !('sourse_sdk_integrated' in topics)`,
    notification: {
      title: title,
      body: body
    }
  }
  return new Promise((resolve, reject) => {
    firebase.messaging().send(payload).then((response) => {
      console.log('Successfully sent message:', response);
      return resolve();
    }).catch((error) => {
      const newError =  new Error("Error sending firebase notification with payload " + JSON.stringify(payload) + ": " + error);
      return reject(newError);
    })
  });
}



/**
 * Send  two notifications: one smart notifications to apps who have integrated the SDK, one standard notification to
 * apps who haven't. 
 * @param {object} firebase firebase admin SDK instance.
 * @param {string} topic the firebase topic to send to
 * @param {string} title notification title, as visible to the end-user 
 * @param {string} body notification body / message, visible to the end-user
 * @param {string} actionURL deep-link URL to invoke when the user taps the notification e.g. myapp://action/item/24343
 * @param {string} tag an optional string to tag this notification with, will show up in analytics
 * @param {Date} expiry an optional date after which the notification will not be shown to the user
 * @oaram {bool} isSmart true if the notification is a smart notification, false if it's not, and should be shown immediately 
 *                even if the app has integrated the Sourse SDK 
 * @returns Promise
 */
async function sendNotification(firebase, topic, title, body, actionURL, tag, expiry, isSmart) {

  const sendSmartPromise = sendSourseSmartNotification(firebase, topic, title, body, actionURL, tag, expiry, isSmart);
  const sendNormalPromise = sendStandardNotification(firebase, topic, title, body);
  // return a promise 
  return Promise.all([sendSmartPromise, sendNormalPromise]);
}




// initialize the firebase admin SDK
var admin = require('firebase-admin');

// replace with your firebase service account 
var serviceAccount = require("./sourse-smartnotif-demo-firebase-adminsdk-462gm-a960a787ad.json.js");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});


console.log("sending two notifications");
sendNotification(admin, 'smartNotificationTest', 'Some title', 'some message', 'hostapp://item/12323', 'weeklies-12323', new Date((new Date()).getTime() + (1000 * 3600))).then(() => {
  console.log("done");
}).catch((error) => {
  console.log("error: " + error);
});
