const functions = require('firebase-functions');

// Import and initialize the Firebase Admin SDK.
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

exports.sendNotification = functions.database.ref('/announcements/{announce_id}').onWrite(event => {
	const ann_id = event.params.announce_id;

	console.log('We are sending notifaction for ', ann_id);

	if(!event.data.val()){
		return console.log('A Notification has been deleted', ann_id);
	}

	const newAnnounce = event.data.val();

	console.log(newAnnounce.author);

	const payload = {
        notification: {
            title: "Announcement: " + newAnnounce.title,
            body: newAnnounce.details,
            sound: "default"
        }       
    };
/* Create an options object that contains the time to live for the notification and the priority. */
    const options = {
        priority: "high",
        timeToLive: 60 * 60 * 24 //24 hours
    };
	return admin.messaging().sendToTopic("announcements", payload, options);
	
});
