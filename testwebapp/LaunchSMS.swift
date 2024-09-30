//
//  LaunchSMS.swift
//  testwebapp
//
//  Created by mmjvox on 9/29/24.
//

import MessageUI
import UIKit

class LaunchSMS: UIViewController, MFMessageComposeViewControllerDelegate {

    // Function to send SMS with a callback
    func sendSMS(recipient: String, messageBody: String, completion: @escaping (MessageComposeResult) -> Void) {
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let rootViewController = windowScene.windows.first?.rootViewController else {
            return
        }
        
        // Check if the device can send text messages
        if MFMessageComposeViewController.canSendText() {
            let messageVC = MFMessageComposeViewController()
            messageVC.body = messageBody  // Set the message body
            messageVC.recipients = [recipient]  // Set the recipient's phone number
            messageVC.messageComposeDelegate = self  // Set delegate
            
            // Assign the completion handler to a property to use later
            self.messageCompletionHandler = completion

            // Present the message compose view
            rootViewController.present(messageVC, animated: true, completion: nil)
        } else {
            // If the device can't send SMS, immediately return a failed result
            completion(.failed)
        }
    }

    // Property to store the callback function
    var messageCompletionHandler: ((MessageComposeResult) -> Void)?

    // Delegate method to handle the result of the SMS operation
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        // Trigger the callback with the result
        messageCompletionHandler?(result)

        // Dismiss the message view controller
        controller.dismiss(animated: true, completion: nil)
    }
}

