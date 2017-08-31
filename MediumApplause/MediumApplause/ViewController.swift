//
//  ViewController.swift
//  MediumApplause
//
//  Created by Ken on 27/08/2017.
//  Copyright © 2017 Ken Boucher. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
  
  var badgerClapper: ApplauseViewController? = nil
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let destination = segue.destination as? ApplauseViewController {
      badgerClapper = destination
    }
  }
  
  @IBAction func sliderValueChanged(_ sender: UISlider) {
    badgerClapper?.timerDelta = Double(sender.value)
  }

}

