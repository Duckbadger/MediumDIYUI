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
	@IBOutlet var circleViews: [CircleView]!
	
	// MARK: Private
	// Animation
	fileprivate let scheduler = ActionScheduler()
	fileprivate var timer: Timer? = nil
	fileprivate let timerDelta = 0.65
	fileprivate var animationCount = 0
	fileprivate var fullAlpha = 0.9
	
	// Frames
	fileprivate lazy var buttonInitialFrame: CGRect = {
		return self.applauseButton.frame
	}()
	fileprivate lazy var applauseCounterViewInitialFrame: CGRect = {
		return self.applauseCounterView.frame
	}()
	fileprivate lazy var applauseCounterViewVisibleFrame: CGRect = {
		return self.applauseCounterViewInitialFrame.offsetBy(dx: 0, dy: -80)
	}()
	fileprivate lazy var applauseCounterViewLeavingFrame: CGRect = {
		return self.applauseCounterViewInitialFrame.offsetBy(dx: 0, dy: -130)
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
		timer?.invalidate()
		timer = Timer.scheduledTimer(timeInterval: timerDelta, target: self, selector: #selector(animateIncrement), userInfo: nil, repeats: true)
	}
	
	fileprivate func scheduleAnimationOut() {
		timer?.invalidate()
		timer = Timer.scheduledTimer(timeInterval: timerDelta, target: self, selector: #selector(animateOut), userInfo: nil, repeats: false)
	}
	
	@objc fileprivate func animateIncrement() {
		// Label
		applauseAmount += 1
		applauseCounterLabel.text = "+\(applauseAmount)"
		
		// Animate Button bounce and stroke
		let buttonGroup = applauseButtonAnimationActions
		
		// Animate applause amount view and increment
		let startFresh = (applauseCounterView.layer.frame == applauseCounterViewInitialFrame || applauseCounterView.layer.frame.midY < applauseCounterViewVisibleFrame.midY)
		let counterActions = startFresh ? applauseCounterAnimationActionsInitial : applauseCounterAnimationActions
		
		let sparkleAnimations = sparklesAnimationActions
		
		let allActions = ActionGroup(actions: [buttonGroup, counterActions, sparkleAnimations])
		
		scheduler.run(action: allActions)
		animationCount += 1
	}
	
	@objc fileprivate func animateOut() {
		let animateLeavingAction = applauseCounterAnimationActionsLeaving
		scheduler.run(action: animateLeavingAction)
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
		let transposeDuration = timerDelta * 0.45
		let fadeDuration = timerDelta * 0.35
		
		let fromRect = applauseCounterViewInitialFrame
		let toRect = applauseCounterViewVisibleFrame
		applauseCounterView.layer.frame = fromRect
		applauseCounterView.alpha = 0
		applauseCounterLabel.layer.frame = fromRect
		applauseCounterLabel.alpha = 0
		let viewAction = InterpolationAction(from: fromRect,
		                                     to: toRect,
		                                     duration: transposeDuration,
		                                     easing: .backOut) { [unowned self] in
												self.applauseCounterView.layer.frame = $0
		}
		let labelAction = InterpolationAction(from: fromRect,
		                                      to: toRect,
		                                      duration: transposeDuration,
		                                      easing: .backOut) { [unowned self] in
												self.applauseCounterLabel.layer.frame = $0
		}
		let fadeAction = InterpolationAction(from: CGFloat(0),
		                                     to: CGFloat(fullAlpha),
		                                     duration: fadeDuration,
		                                     easing: .linear,
		                                     update: { [unowned self] in
												self.applauseCounterView.alpha = $0
												self.applauseCounterLabel.alpha = $0
		})
		
		return ActionGroup(actions: [viewAction, labelAction, fadeAction])
	}
	
	fileprivate var applauseCounterAnimationActionsLeaving: FiniteTimeAction {
		let transposeDuration = timerDelta * 0.8
		let fadeDuration = timerDelta * 0.5
		
		let fromRect = applauseCounterViewVisibleFrame
		let toRect = applauseCounterViewLeavingFrame
		let viewAction = InterpolationAction(from: fromRect,
		                                     to: toRect,
		                                     duration: transposeDuration,
		                                     easing: .backOut) { [unowned self] in
												self.applauseCounterView.layer.frame = $0
		}
		let labelAction = InterpolationAction(from: fromRect,
		                                      to: toRect,
		                                      duration: transposeDuration,
		                                      easing: .backOut) { [unowned self] in
												self.applauseCounterLabel.layer.frame = $0
		}
		let fadeAction = InterpolationAction(from: CGFloat(fullAlpha),
		                                     to: CGFloat(0),
		                                     duration: fadeDuration,
		                                     easing: .linear,
		                                     update: { [unowned self] in
												self.applauseCounterView.alpha = $0
												self.applauseCounterLabel.alpha = $0
		})
		
		return ActionGroup(actions: [viewAction, labelAction, fadeAction])

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
	
	// ✨
	fileprivate var sparklesAnimationActions: FiniteTimeAction {
		let transposeDuration = timerDelta * 0.45
		let fadeDuration = timerDelta * 0.21
		
		let angleDelta = 360 / 5
		let startAngle = Int(arc4random()) % angleDelta
		let distance: Double = 25
		
		let origin = CGPoint(x: applauseCounterViewVisibleFrame.midX, y: applauseCounterViewVisibleFrame.midY)
		let initialDistanceFromOrigin = (Double(applauseCounterViewVisibleFrame.size.width) / 2) + 5
		let endDistanceFromOrigin = initialDistanceFromOrigin + distance
		
		var sparkleActions: [FiniteTimeAction] = []
		let triangleActions = triangleAnimationActions(withAngle: startAngle, angleDelta: angleDelta, origin: origin, initialDistanceFromOrigin: initialDistanceFromOrigin, endDistanceFromOrigin: endDistanceFromOrigin, transposeDuration: transposeDuration, fadeDuration: fadeDuration)
		sparkleActions.append(contentsOf: triangleActions)
		
		let circleActions = circleAnimationActions(withAngle: startAngle, angleDelta: angleDelta, origin: origin, initialDistanceFromOrigin: initialDistanceFromOrigin, endDistanceFromOrigin: endDistanceFromOrigin, transposeDuration: transposeDuration, fadeDuration: fadeDuration)
		sparkleActions.append(contentsOf: circleActions)
		
		return ActionGroup(actions: sparkleActions)
	}
	
	fileprivate func triangleAnimationActions(withAngle startAngle: Int,
	                                        angleDelta: Int,
	                                        origin: CGPoint,
	                                        initialDistanceFromOrigin: Double,
	                                        endDistanceFromOrigin: Double,
	                                        transposeDuration: Double,
	                                        fadeDuration: Double) -> [FiniteTimeAction] {
		var sparkleActions: [FiniteTimeAction] = []
		
		for (index, triangle) in triangleViews.enumerated() {
			let angle = Double(startAngle + (angleDelta * index))
			
			triangle.layer.transform = CATransform3DMakeRotation(CGFloat(angle - 90.0) / 180.0 * CGFloat(Double.pi), 0, 0, 1)
			
			let startPoint = CGPoint(x: Double(origin.x) + initialDistanceFromOrigin * cos(angle / 180.0 * Double.pi),
			                         y: Double(origin.y) + initialDistanceFromOrigin * sin(angle / 180.0 * Double.pi))
			let endPoint = CGPoint(x: Double(origin.x) + endDistanceFromOrigin * cos(angle / 180.0 * Double.pi),
			                       y: Double(origin.y) + endDistanceFromOrigin * sin(angle / 180.0 * Double.pi))
			let transposeAction = InterpolationAction(from: startPoint,
			                                          to: endPoint,
			                                          duration: transposeDuration,
			                                          easing: .sineOut) {
														triangle.layer.position = $0
			}
			let fadeAction = InterpolationAction(from: 0.0,
			                                     to: Float(fullAlpha),
			                                     duration: fadeDuration,
			                                     easing: .sineOut,
			                                     update: {
													triangle.layer.opacity = $0
			}).yoyo()
			let actionGroup = ActionGroup(actions: [transposeAction, fadeAction])
			sparkleActions.append(actionGroup)
		}
		
		return sparkleActions
	}
	
	fileprivate func circleAnimationActions(withAngle startAngle: Int,
	                                        angleDelta: Int,
	                                        origin: CGPoint,
	                                        initialDistanceFromOrigin: Double,
	                                        endDistanceFromOrigin: Double,
	                                        transposeDuration: Double,
	                                        fadeDuration: Double) -> [FiniteTimeAction] {
		let circleTriangleRatio = 0.75
		var sparkleActions: [FiniteTimeAction] = []
		
		for (index, circle) in circleViews.enumerated() {
			let angle = Double(startAngle - 10 + (angleDelta * index))
			
			let startPoint = CGPoint(x: Double(origin.x) + (initialDistanceFromOrigin - 4) * cos(angle / 180.0 * Double.pi),
			                         y: Double(origin.y) + (initialDistanceFromOrigin - 4) * sin(angle / 180.0 * Double.pi))
			let endPoint = CGPoint(x: Double(origin.x) + (endDistanceFromOrigin * circleTriangleRatio) * cos(angle / 180.0 * Double.pi),
			                       y: Double(origin.y) + (endDistanceFromOrigin * circleTriangleRatio) * sin(angle / 180.0 * Double.pi))
			
			let transposeAction = InterpolationAction(from: startPoint,
			                                          to: endPoint,
			                                          duration: transposeDuration,
			                                          easing: .sineOut) {
														circle.layer.position = $0
			}
			let fadeAction = InterpolationAction(from: 0.0,
			                                     to: Float(fullAlpha),
			                                     duration: fadeDuration,
			                                     easing: .sineOut,
			                                     update: {
													circle.layer.opacity = $0
			}).yoyo()
			
			let actionGroup = ActionGroup(actions: [transposeAction, fadeAction])
			sparkleActions.append(actionGroup)
		}
		
		return sparkleActions
	}
	
	// MARK: Actions
	
	@IBAction func applauseButtonTouchDown(_ sender: Any) {
		scheduleIncrement()
	}

	@IBAction func applauseButtonTouchUp(_ sender: Any) {
		scheduleAnimationOut()
	}
}
