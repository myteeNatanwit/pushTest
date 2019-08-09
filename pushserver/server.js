"use strict";
  
const apn = require('apn');
  
  let options = {
    token: {
      key: "AuthKey_Z692H6MNDF.p8",
      keyId: "Z692H6MNDF",
     teamId: "VTRUVT3ZRQ"
   },
   production: false
 };
 
 let apnProvider = new apn.Provider(options);
 
 // Replace deviceToken with your particular token:
 let deviceToken = "175eec849617678f67cce068d32732ce6cacc8fb9539f7bb5b28a0648aa15ad3";
 
 // Prepare the notifications
 let notification = new apn.Notification();
 notification.expiry = Math.floor(Date.now() / 1000) + 24 * 3600; // will expire in 24 hours from now
 notification.title = "this is titlte";
 notification.badge = 1;
 notification.sound = "ping.aiff";
 notification.category = "custom1";
 notification.alert = "\uD83D\uDCE7 \u2709 You have a new message";
 notification.payload = {'messageFrom': 'John Doe'};
 notification.topic = "apushhere"; // Replace this with your app bundle ID:
 
 // Send the actual notification
 apnProvider.send(notification, deviceToken).then( result => {
 	// Show the result of the send operation:
 	console.log(result);
 });
 
 
 // Close the server, it takes a while to really shutdown
apnProvider.shutdown();