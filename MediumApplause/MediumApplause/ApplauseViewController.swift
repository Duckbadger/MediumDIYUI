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
	
	// MARK: - Properties
	// MARK: Outlets
	@IBOutlet var applauseButton: UIButton!
	@IBOutlet var applauseCounterView: UIView!
	@IBOutlet var applauseCounterLabel: UILabel!
	
	@IBOutlet var triangleViews: [UIView]!
	
	// MARK: Private
	// Animation
	fileprivate let scheduler = ActionScheduler()
	fileprivate var timer: Timer? = nil
	fileprivate let timerDelta = 0.6
	fileprivate var animationCount = 0
	
	// Frames
	fileprivate lazy var buttonInitialFrame: CGRect = {
		return self.applauseButton.frame
	}()
	fileprivate lazy var applauseCounterViewInitialFrame: CGRect = {
		return self.applauseCounterView.frame
	}()
	fileprivate lazy var applauseCounterViewVisibleFrame: CGRect = {
		return self.applauseCounterViewInitialFrame.offsetBy(dx: 0, dy: -100)
	}()
	
	fileprivate var applauseAmount = 0

	override func viewDidLoad() {
		super.viewDidLoad()
		setupApplauseButton()
		setupApplauseAmountContainer()
	}
	
	// MARK: - Functions
	// MARK: Applause
	
	fileprivate func setupApplauseButton() {
		applauseButton.layer.cornerRadius = buttonInitialFrame.width / 2
		applauseButton.layer.borderWidth = 2.0
		applauseButton.layer.borderColor = UIColor.red.cgColor
	}
	
	fileprivate func setupApplauseAmountContainer() {
		applauseCounterView.layer.cornerRadius = applauseCounterViewInitialFrame.width / 2
	}
	
	fileprivate func scheduleIncrement() {
		animationCount = 0
		animateIncrement()
		timer = Timer.scheduledTimer(timeInterval: timerDelta, target: self, selector: #selector(animateIncrement), userInfo: nil, repeats: true)
	}
	
	fileprivate func scheduleAnimationOut() {
		
	}
	
	@objc fileprivate func animateIncrement() {
		// Label
		applauseAmount += 1
		applauseCounterLabel.text = "+\(applauseAmount)"
		
		// Animate Button bounce and stroke
		let buttonGroup = applauseButtonAnimationActions
		
		// Animate applause amount view and increment
		let counterActions = (applauseCounterView.layer.frame == applauseCounterViewInitialFrame) ? applauseCounterAnimationActionsInitial : applauseCounterAnimationActions
		
		let sparkleAnimations = sparklesAnimationActions
		
		let allActions = ActionGroup(actions: [buttonGroup, counterActions, sparkleAnimations])
		
		scheduler.run(action: allActions)
		animationCount += 1
	}
	
	fileprivate var applauseButtonAnimationActions: FiniteTimeAction {
		let animationDuration = timerDelta * 0.45
		
		let fromRect = buttonInitialFrame
		let delta = CGFloat(-4)
		let toRect = buttonInitialFrame.insetBy(dx: delta, dy: delta)
		let buttonAction = InterpolationAction(from: fromRect,
		                                       to: toRect,
		                                       duration: animationDuration,
		                                       easing: .sineInOut) { [unowned self] in
												self.applauseButton.layer.frame = $0
		}
		
		let fromWidth = fromRect.width
		let toWidth = toRect.width
		let cornerAction = InterpolationAction(from: fromWidth * 0.5,
		                                       to: toWidth * 0.5,
		                                       duration: animationDuration,
		                                       easing: .sineInOut) { [unowned self] in
												self.applauseButton.layer.cornerRadius = $0
		}
		
		return ActionGroup(actions: [buttonAction, cornerAction]).yoyo()
	}
	
	fileprivate var applauseCounterAnimationActionsInitial: FiniteTimeAction {
		let animationDuration = timerDelta * 0.45
		
		// Container view
		let fromRect = applauseCounterViewInitialFrame
		let toRect = applauseCounterViewVisibleFrame
		let viewAction = InterpolationAction(from: fromRect,
		                                     to: toRect,
		                                     duration: animationDuration,
		                                     easing: .backOut) { [unowned self] in
												self.applauseCounterView.layer.frame = $0
		}
		let labelAction = InterpolationAction(from: fromRect,
		                                      to: toRect,
		                                      duration: animationDuration,
		                                      easing: .backOut) { [unowned self] in
												self.applauseCounterLabel.layer.frame = $0
		}
		
		return ActionGroup(actions: [viewAction, labelAction])
	}
	
	fileprivate var applauseCounterAnimationActions: FiniteTimeAction {
		let animationDuration = timerDelta * 0.45
		
		// Container view
		let fromRect = applauseCounterViewVisibleFrame
		let delta = CGFloat(-2)
		let toRect = applauseCounterViewVisibleFrame.insetBy(dx: delta, dy: delta)
		let viewAction = InterpolationAction(from: fromRect,
		                                     to: toRect,
		                                     duration: animationDuration,
		                                     easing: .sineInOut) { [unowned self] in
												self.applauseCounterView.layer.frame = $0
		}
		
		let labelFromRect = applauseCounterViewVisibleFrame
		let labelToRect = applauseCounterViewVisibleFrame
		let labelAction = InterpolationAction(from: labelFromRect,
		                                     to: labelToRect,
		                                     duration: animationDuration,
		                                     easing: .sineInOut) { [unowned self] in
												self.applauseCounterLabel.layer.frame = $0
		}
		
		
		let fromWidth = fromRect.width
		let toWidth = toRect.width
		let cornerAction = InterpolationAction(from: fromWidth * 0.5,
		                                       to: toWidth * 0.5,
		                                       duration: animationDuration,
		                                       easing: .sineInOut) { [unowned self] in
												self.applauseCounterView.layer.cornerRadius = $0
		}
		
		return ActionGroup(actions: [viewAction, labelAction, cornerAction]).yoyo()
	}
	
	fileprivate var applauseCounterLabelAnimationActions: FiniteTimeAction {
		applauseAmount += 1
		
		let fromString = applauseCounterLabel.text!
		let toString = "\(applauseAmount)"
		let labelAction = InterpolationAction(from: fromString,
		                                       to: toString,
		                                       duration: 0.1,
		                                       easing: .sineInOut) { [unowned self] in
												self.applauseCounterLabel.text = $0
		}
		
		return labelAction
	}
	
	fileprivate var sparklesAnimationActions: FiniteTimeAction {
		let transposeDuration = timerDelta * 0.45
		let fadeDuration = timerDelta * 0.4
		
		let angleDelta = 360 / 5
		let startAngle = Int(arc4random()) % angleDelta
		let distance: Double = 25
		
		let origin = CGPoint(x: applauseCounterViewVisibleFrame.midX, y: applauseCounterViewVisibleFrame.midY)
		let initialDistanceFromOrigin = (Double(applauseCounterViewVisibleFrame.size.width) / 2) + 5
		let endDistanceFromOrigin = initialDistanceFromOrigin + distance
		
		
		var triangleActions: [FiniteTimeAction] = []
		for (index, triangle) in triangleViews.enumerated() {
			let triangleAngle = Double(startAngle + (angleDelta * index))
			
			triangle.layer.transform = CATransform3DMakeRotation(CGFloat(triangleAngle - 90.0) / 180.0 * CGFloat(Double.pi), 0, 0, 1)
			
			let startPoint = CGPoint(x: Double(origin.x) + initialDistanceFromOrigin * cos(triangleAngle / 180.0 * Double.pi),
			                         y: Double(origin.y) + initialDistanceFromOrigin * sin(triangleAngle / 180.0 * Double.pi))
			let endPoint = CGPoint(x: Double(origin.x) + endDistanceFromOrigin * cos(triangleAngle / 180.0 * Double.pi),
			                       y: Double(origin.y) + endDistanceFromOrigin * sin(triangleAngle / 180.0 * Double.pi))
			let transposeAction = InterpolationAction(from: startPoint,
			                                 to: endPoint,
			                                 duration: transposeDuration,
			                                 easing: .sineOut) {
												triangle.layer.position = $0
			}
			let fadeAction = InterpolationAction(from: 0,
			                                     to: 1,
			                                     duration: fadeDuration,
			                                     easing: .linear,
			                                     update: {
													triangle.layer.opacity = $0
			}).yoyo()
			let actionGroup = ActionGroup(actions: [transposeAction, fadeAction])
			triangleActions.append(actionGroup)
		}
		
		return ActionGroup(actions: triangleActions)
	}
	
	// MARK: Actions
	
	@IBAction func applauseButtonTouchDown(_ sender: Any) {
		scheduleIncrement()
	}

	@IBAction func applauseButtonTouchUp(_ sender: Any) {
		timer?.invalidate()
		scheduleAnimationOut()
	}
}
