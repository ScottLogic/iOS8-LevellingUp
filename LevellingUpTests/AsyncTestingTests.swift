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

import XCTest
import LevellingUp
import UIKit

class HorseRaceTests: XCTestCase {
  
  var viewController: AsyncTestingViewController!
  var raceController: TwoHorseRaceController!
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // Get hold of the view controller
    let window = UIApplication.sharedApplication().delegate?.window!
    let storyboard = window?.rootViewController!.storyboard
    
    
    viewController = storyboard?.instantiateViewControllerWithIdentifier("AsyncTestingVC") as! AsyncTestingViewController
    window?.rootViewController = viewController
    raceController = viewController.raceController
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    viewController.raceController.reset()
    super.tearDown()
  }
  
  func testBasicAsyncMethod() {
    // Check that we get called back as expected
    let expectation = expectationWithDescription("Async Method")
    
    raceController.someKindOfAsyncMethod({
      expectation.fulfill()
    })
    
    waitForExpectationsWithTimeout(5, handler: nil)
  }
  
  
  func testRaceCallbacks() {
    // The horse race controller should callback each time a horse completes
    // the race.
    let h1Expectation = expectationWithDescription("Horse 1 should complete")
    let h2Expectation = expectationWithDescription("Horse 2 should complete")
    
    raceController.startRace(3, horseCrossedLineCallback: {
      (horse: Horse) in
      switch horse.horseView {
      case self.viewController.horse1:
        h1Expectation.fulfill()
      case self.viewController.horse2:
        h2Expectation.fulfill()
      default:
        XCTFail("Completetion called with unknown horse")
      }
    })
    
    waitForExpectationsWithTimeout(5, handler: nil)
  }
  
  func testResetButtonEnabledOnceRaceComplete() {
    let expectation = keyValueObservingExpectationForObject(viewController.resetButton, keyPath: "enabled", expectedValue: true)
    
    // Simulate tapping the start race button
    viewController.handleStartRaceButton(viewController.startRaceButton)
    
    // Wait for the test to run
    waitForExpectationsWithTimeout(5, handler: nil)
  }
}
