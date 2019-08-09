
//  Created by Admin on 30/7/19.
//  Copyright © 2019 Admin. All rights reserved.
//
/*
 1- use pushkey p8 for server push send.
 2- register app id with push
 3- reg cert for dev n dis - same cert request?
 4- add provisional profile matching with push app ID
 - payload {"aps":  {"alert":"Chinese medicine Round pill making machine",  "badge":3,  "sound" : "default",
 "mutable-content": 1, // this is to trigger the serviceextention added as target
 "category": "custom1" // this is to present the custom key in category
 },  "yourCustomKey":"1" // can add anything here
 }
  */
import UIKit
import UserNotifications


class ViewController: UIViewController {
    var messageSubtitle = "Staff Meeting in 20 minutes";

    @IBOutlet weak var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        valNotification ();
    }


}
extension ViewController: UNUserNotificationCenterDelegate {
    func valNotification () {
        UNUserNotificationCenter.current().delegate = self;
        // user category 1 - response for "category": "custom1" in push payload
        let repeatAction = UNNotificationAction(identifier: "repeat", title: "Repeat", options: [])
        let changeAction = UNTextInputNotificationAction(identifier: "change", title: "Change Message", options: [])
        let category = UNNotificationCategory(identifier: "custom1",
                                              actions: [repeatAction, changeAction],
                                              intentIdentifiers: [], options: [])

// user category 2 - response for "category": "custom2" in push payload
        let likeAction = UNNotificationAction(identifier: "like", title: "Like", options: [])
        let saveAction = UNNotificationAction(identifier: "save", title: "Save", options: [])
        let category2 = UNNotificationCategory(identifier: "custom2", actions: [likeAction, saveAction], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category, category2])


        let options: UNAuthorizationOptions = [.alert, .sound, .badge];
        UNUserNotificationCenter.current().requestAuthorization(options: options) {
            (granted, error) in
            if !granted {
                print("Something went wrong")
            }

        }
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            switch settings.showPreviewsSetting {
            case .always:
                print("Always")
            case .whenAuthenticated:
                print("When unlocked")
            case .never:
                print("Never");
            default: return;
            };
            switch settings.authorizationStatus {

            case .authorized: break;
                // Schedule Local Notification
            case .denied:
                print("Application Not Allowed to Display Notifications");

            case .provisional:
                return;
            case .notDetermined:
                print("no setting")
                @unknown default:
                return;
            }

            if settings.authorizationStatus != .authorized {
                print("Notifications not allowed");
            }
        }
    }

    func sendNotification(txt: String) {
        let content = UNMutableNotificationContent()
        content.title = "Notification Title";
        content.subtitle = messageSubtitle;
        content.body = txt;
        content.sound = UNNotificationSound.default;
        content.badge = 1;

        content.categoryIdentifier = "custom1";

        let imageName = "gear";
        guard let imageURL = Bundle.main.url(forResource: imageName, withExtension: "png") else { return }
        let attachment = try! UNNotificationAttachment(identifier: imageName, url: imageURL, options: .none)
        content.attachments = [attachment]

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let requestIdentifier = "demoNotification";
        let request = UNNotificationRequest(identifier: requestIdentifier,
                                            content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
            // Handle error
        })
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        label.text = notification.request.content.body;
        completionHandler([.alert, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive
    response: UNNotificationResponse, withCompletionHandler completionHandler:
        @escaping () -> Void) {
        //      print(response.actionIdentifier);
        switch response.actionIdentifier {
        case "repeat":
            self.sendNotification(txt: "Repeat Notification");
        case "change":
            let textResponse = response
            as! UNTextInputNotificationResponse
            messageSubtitle = textResponse.userText
            self.sendNotification(txt: "change subtitle")
        default:
            break
        }
        completionHandler()
    }
}

