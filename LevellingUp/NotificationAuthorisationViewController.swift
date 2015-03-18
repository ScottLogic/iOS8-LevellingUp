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

class NotificationAuthorisationViewController: UIViewController {
  
  let red = UIColor.redColor()
  let green = UIColor.greenColor()
  
  @IBOutlet weak var badgesLabel: UILabel!
  @IBOutlet weak var soundsLabel: UILabel!
  @IBOutlet weak var alertsLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: "updateLabelsWithCurrentStatus",
      name: userNotificationSettingsKey,
      object: nil)
    
    // Do any additional setup after loading the view.
    updateLabelsWithCurrentStatus()
  }
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  // MARK:- Actions
  @IBAction func handleRequestAction(sender: AnyObject) {
    let requestedTypes: UIUserNotificationType = .Alert | .Sound | .Badge
    requestNotificationsForTypes(requestedTypes)
  }
  
  // MARK:- Utils
  func updateLabelsWithCurrentStatus() {
    let types = UIApplication.sharedApplication().currentUserNotificationSettings().types
    
    badgesLabel.backgroundColor = (types & UIUserNotificationType.Badge == nil) ? red : green
    alertsLabel.backgroundColor = (types & UIUserNotificationType.Alert == nil) ? red : green
    soundsLabel.backgroundColor = (types & UIUserNotificationType.Sound == nil) ? red : green
  }
  
  private func requestNotificationsForTypes(types: UIUserNotificationType) {
    let settingsRequest = UIUserNotificationSettings(forTypes: types, categories: nil)
    UIApplication.sharedApplication().registerUserNotificationSettings(settingsRequest)
  }
  
  
}
