//
//  TriangleView.swift
//  MediumApplause
//
//  Created by Ken on 29/08/2017.
//  Copyright © 2017 Ken Boucher. All rights reserved.
//

import UIKit

final class TriangleView : UIView {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func draw(_ rect: CGRect) {
		
		guard let context = UIGraphicsGetCurrentContext() else { return }
		
		context.beginPath()
		context.move(to: CGPoint(x: rect.minX, y: rect.maxY))
		context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
		context.addLine(to: CGPoint(x: (rect.maxX / 2.0), y: rect.minY))
		context.closePath()
		
		context.setFillColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 0.60)
		context.fillPath()
	}
}

final class CircleView: UIView {
	
	override func layoutSubviews() {
		super.layoutSubviews()
		layer.cornerRadius = bounds.size.width / 2;
		layer.masksToBounds = true;
	}
	
}
