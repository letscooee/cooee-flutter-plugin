//
//  NotificationService.swift
//  NotificationService
//
//  Created by Ashish Gaikwad on 25/01/22.
//

import UserNotifications
import CooeeSDK

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = CooeeNotificationService.updateContentFromRequest(request)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            
            contentHandler(bestAttemptContent)
        }else{
            contentHandler(request.content)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
