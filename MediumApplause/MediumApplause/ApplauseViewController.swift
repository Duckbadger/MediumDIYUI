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
	fileprivate let timerDelta = 0.5
	fileprivate lazy var buttonInitialFrame: CGRect = {
		return self.applauseButton.frame
	}()

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
		timer = Timer.scheduledTimer(timeInterval: timerDelta, target: self, selector: #selector(animateIncrement), userInfo: nil, repeats: true)
	}
	
	@objc fileprivate func animateIncrement() {
		print("animate")
		
		// Animate Button bounce and stroke
		
		let buttonDuration = timerDelta * 0.5
		
		let fromRect = buttonInitialFrame
		let frameDelta = CGFloat(-4)
		let toRect = buttonInitialFrame.insetBy(dx: frameDelta, dy: frameDelta)
		let buttonAction = InterpolationAction(from: fromRect,
		                                       to: toRect,
		                                       duration: buttonDuration,
		                                       easing: .sineInOut) { [unowned self] in
												self.applauseButton.layer.frame = $0
		}
		let fromWidth = fromRect.width
		let toWidth = toRect.width
		let cornerAction = InterpolationAction(from: fromWidth * 0.5,
		                                       to: toWidth * 0.5,
		                                       duration: buttonDuration,
		                                       easing: .sineInOut) { [unowned self] in
												self.applauseButton.layer.cornerRadius = $0
		}
		
		let buttonGroup = ActionGroup(actions: [buttonAction, cornerAction])
		
		scheduler.run(action: buttonGroup.yoyo())
	}
	
	// MARK: Actions
	
	@IBAction func applauseButtonTouchDown(_ sender: Any) {
		scheduleIncrement()
	}

	@IBAction func applauseButtonTouchUp(_ sender: Any) {
		timer?.invalidate()
	}
}
