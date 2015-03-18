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

class MasterViewController: UITableViewController {
  
  let appStructure = AppComponent.appStructure()

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  // MARK: - Row Selection
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let component = appStructure[indexPath.row]
    var newVC: UIViewController?
    
    switch component.type {
    case .Storyboard(let vcIdentifier):
      newVC = storyboard?.instantiateViewControllerWithIdentifier(vcIdentifier) as? UIViewController
    case .Code(let instantiation):
      newVC = instantiation(storyboard)
    }
    
    if let newVC = newVC {
      showDetailViewController(newVC, sender: self)
    }
  }

  // MARK: - Table View
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return AppComponentCategory.allValues.count
  }
  
  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return AppComponentCategory.allValues[section].rawValue
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return appStructure.filter({ $0.category == AppComponentCategory.allValues[section] }).count
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell

    let component = appStructure.filter({ $0.category == AppComponentCategory.allValues[indexPath.section] })[indexPath.row]
    cell.textLabel!.text = component.name
    return cell
  }


}

