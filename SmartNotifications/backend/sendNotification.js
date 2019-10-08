
/**
 * Send a notification using the Firebase admin SDK. Use condition to send this notification
 * only to client which have integrated the sourse ISDK. 
 *
 * @param {object} firebase firebase admin SDK instance.
 * @param {string} topic the firebase topic to send to
 * @param {string} title notification title, as visible to the end-user 
 * @param {string} body notification body / message, visible to the end-user
 * @param {string} actionURL an optional deep-link URL to invoke when the user taps the notification e.g. myapp://action/item/24343
 * @param {string} imageURL an optional URL to an image to be displayed as a notification attachement
 * @param {string} tag an optional string to tag this notification with, will show up in analytics
 * @param {Date} expiry an optional date after which the notification will not be shown to the user
 * @oaram {boolean} isSmart true if the notification is a smart notification, false if it's not, and should be shown immediately 
 * @param {object} customPayload custom payload to include in remote notification
 * @returns Promise
 */ 
async function sendSourseSmartNotification(firebase, topic, title, body, actionURL, imageURL, tag, expiry, isSmart, customPayload) {
  var payload = {
    condition: `'${topic}' in topics && 'sourse_sdk_integrated' in topics`,
    data: {
      "handler": "com.sourse.notification",
      "title": title,
      "message": body
    }
  }
	
	if (expiry != null)	{
		payload.data["expiryDate"] = expiry.toISOString();
  }
  
  if (imageURL != null) {
    payload.data["imageURL"] = imageURL;
    
  }
  if (actionURL != null) {
    payload.data["actionURL"] = actionURL;
  }
	
	if (tag != null) {
		payload.data["tag"] = tag;
  }

  if (isSmart != null) {
    payload.data["isSmartNotification"] = isSmart ? '1' : '0';
  }

  if (customPayload != null) {
    for (let [key, value] of Object.entries(customPayload)) {
      const newKey = "custom_" + key;
      payload.data[newKey] = value;
    }
  }

  return new Promise((resolve, reject) => {
    firebase.messaging().send(payload).then((response) => {
      console.log("Successfully sent message:", response);
      return resolve();
    }).catch((error) => {
      const newError =  new Error("Error sending firebase notification with payload " + JSON.stringify(payload) + ": " + error);
      return reject(error);
    })
  });
}


/**
 * Send a notification using the Firebase admin SDK. Use condition to send this notification
 * only to client which have NOT integrated the sourse ISDK
 *
 * @param {object} firebase firebase admin SDK instance.
 * @param {string} topic the firebase topic to send to
 * @param {string} title notification title, as visible to the end-user 
 * @param {string} body notification body / message, visible to the end-user
 * @param {object} customPayload custom payload to include in remote notification 
 */ 
async function sendStandardNotification(firebase, topic, title, body, customPayload) {
  var payload = {
    condition: `'${topic}' in topics && !('sourse_sdk_integrated' in topics)`,
    notification: {
      title: title,
      body: body
    }
  }

  if (customPayload != null) {
    payload["data"] = customPayload
  }

  return new Promise((resolve, reject) => {
    firebase.messaging().send(payload).then((response) => {
      console.log("Successfully sent message:", response);
      return resolve();
    }).catch((error) => {
      const newError =  new Error("Error sending firebase notification with payload " + JSON.stringify(payload) + ": " + error);
      return reject(error);
    })
  });
}


/**
 * Send  two notifications: one smart notifications to apps who have integrated the SDK, one standard notification to
 * apps who haven't. 
 * @param {} firebase 
 * @param {*} topic 
 * @param {*} title 
 * @param {*} body 
 * @param {*} actionURL 
 * @param {*} tag 
 * @param {*} expiry 
 * @param {*} isSmart 
 */
async function sendNotification(firebase, topic, title, body, actionURL, imageURL, tag, expiry, isSmart, customPayload) {

  const sendSmartPromise = sendSourseSmartNotification(firebase, topic, title, body, actionURL, imageURL, tag, expiry, isSmart, customPayload);
  const sendNormalPromise = sendStandardNotification(firebase, topic, title, body, customPayload);
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
sendNotification(admin, "smartNotificationTest", "Some title", "some message", "hostapp://item/12323", "weeklies-12323", new Date((new Date()).getTime() + (1000 * 3600)), null).then(() => {
  console.log("done");
}).catch((error) => {
  console.log("error: " + error);
});
