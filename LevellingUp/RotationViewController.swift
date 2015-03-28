//
// Copyright 2014 Scott Logic
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

class RotationViewController: UIViewController {
  
  @IBOutlet var monkeyLabels: [UILabel]!
  
  override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
    let targetTransform = coordinator.targetTransform()
    if !CGAffineTransformIsIdentity(targetTransform) {
      coordinator.animateAlongsideTransition({
        context in
        UIView.animateWithDuration(context.transitionDuration()) {
          for monkey in self.monkeyLabels {
            monkey.transform = CGAffineTransformInvert(targetTransform)
          }
        }
      }, completion: {
        context in
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.3,
          initialSpringVelocity: 0, options: .allZeros, animations: {
            for monkey in self.monkeyLabels {
              monkey.transform = CGAffineTransformIdentity
            }
          },
          completion: nil)
      })
    }
  }
}
