//
//  ApplauseViewController.swift
//  MediumApplause
//
//  Created by Ken on 28/08/2017.
//  Copyright © 2017 Ken Boucher. All rights reserved.
//

import UIKit
import TweenKit

final class ApplauseViewController: UIViewController {
	
	@IBOutlet var applauseButton: UIButton!
	
	fileprivate let scheduler = ActionScheduler()
	fileprivate var timer: Timer? = nil

	override func viewDidLoad() {
		super.viewDidLoad()
		setupApplauseButton()
	}
	
	// MARK: Private
	
	fileprivate func setupApplauseButton() {
		applauseButton.layer.cornerRadius = applauseButton.frame.width / 2
		applauseButton.layer.borderWidth = 2.0
		applauseButton.layer.borderColor = UIColor.red.cgColor
	}
	
	fileprivate func scheduleIncrement() {
		animateIncrement()
		timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(animateIncrement), userInfo: nil, repeats: true)
	}
	
	@objc fileprivate func animateIncrement() {
		
	}
	
	// MARK: Actions
	
	@IBAction func applauseButtonTouchDown(_ sender: Any) {
		scheduleIncrement()
	}

	@IBAction func applauseButtonTouchUp(_ sender: Any) {
		timer?.invalidate()
	}
}
