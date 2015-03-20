//
// Copyright 2015 Scott Logic
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import UIKit

class NotificationActionsViewController: UIViewController {
  
  let notificationActionDemoString = "AskMeNotificationString"
  let cancelNotificationString = "CancelNotificationString"
  let askAgainNotificationString = "AskAgainNotificationString"
  
  @IBOutlet weak var lastAskedLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Request authorisation for local notifications
    let requestedTypes = UIUserNotificationType.Alert
    let category = prepareNotificationCategory()
    let settingsRequest = UIUserNotificationSettings(forTypes: requestedTypes, categories: [category])
    UIApplication.sharedApplication().registerUserNotificationSettings(settingsRequest)
    
    // Handle local notifications being fired
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleLocalNotificationReceived:", name: localNotificationFiredKey, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleNotificationAction:", name: localNotificationTriggeredActionKey, object: nil)
  }
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }

  @IBAction func handleAskMeLaterPressed(sender: AnyObject) {
    // Cancel any existing notifications
    UIApplication.sharedApplication().cancelAllLocalNotifications()
    
    // Create a new notification
    let notification = UILocalNotification()
    notification.fireDate = NSDate(timeIntervalSinceNow: 3)
    notification.alertBody = "Asking you now"
    notification.category = notificationActionDemoString
    
    // Schedule Notification
    UIApplication.sharedApplication().scheduleLocalNotification(notification)
  }
  
  
  // Notification handling
  func handleLocalNotificationReceived(notification: NSNotification) {
    lastAskedLabel.text = "You Answered!"
  }
  
  // Action handling
  func handleNotificationAction(notification: NSNotification) {
    if let userInfo = notification.userInfo,
      let userNotification = userInfo["notification"] as? UILocalNotification,
      let identifier = userInfo["identifier"] as? String {
        switch identifier {
        case cancelNotificationString:
          lastAskedLabel.text = "You cancelled"
        case askAgainNotificationString:
          lastAskedLabel.text = "You restarted!"
          handleAskMeLaterPressed(lastAskedLabel)
        default:
          break
        }
    }
  }
    
  
  // MARK:- Utiltiies
  private func prepareNotificationCategory() -> UIUserNotificationCategory {
    let cancelAction = UIMutableUserNotificationAction()
    cancelAction.identifier = cancelNotificationString
    cancelAction.destructive = true
    cancelAction.title = "Cancel"
    // Should the app be started in the foreground to handle the request?
    cancelAction.activationMode = .Background
    cancelAction.authenticationRequired = false
    
    let askAgainAction = UIMutableUserNotificationAction()
    askAgainAction.identifier = askAgainNotificationString
    askAgainAction.destructive = false
    askAgainAction.title = "AskAgain?"
    askAgainAction.activationMode = .Foreground
    askAgainAction.authenticationRequired = true
    
    
    let category = UIMutableUserNotificationCategory()
    category.identifier = notificationActionDemoString
    category.setActions([cancelAction, askAgainAction], forContext: .Minimal)
    return category
  }

}
