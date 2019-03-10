//
//  DieView.swift
//  Dice
//
//  Created by Adam Preble on 8/22/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

import Cocoa

class DieView: NSView {
	
	var intValue: Int? = 1 {
		didSet {
			needsDisplay = true
		}
	}
	
	override var intrinsicContentSize: NSSize {
		return NSSize(width: 20, height: 20)
	}

	override func draw(_ dirtyRect: NSRect) {
		let backgroundColor = NSColor.lightGray
		backgroundColor.set()
		NSBezierPath.fill(bounds)
		
		drawDieWithSize(bounds.size)
	}
	
	func metricsForSize(_ size: CGSize) -> (edgeLength: CGFloat, dieFrame: CGRect) {
		let edgeLength = min(size.width, size.height)
		let padding = edgeLength/10.0
		let drawingBounds = CGRect(x: 0, y: 0, width: edgeLength, height: edgeLength)
		let dieFrame = drawingBounds.insetBy(dx: padding, dy: padding)
		return (edgeLength, dieFrame)
	}
	
	func drawDieWithSize(_ size: CGSize) {
		if let intValue = intValue {
			let (edgeLength, dieFrame) = metricsForSize(size)
			let cornerRadius: CGFloat = edgeLength/5.0
			let dotRadius = edgeLength/12.0
			let dotFrame = dieFrame.insetBy(dx: dotRadius * 2.5, dy: dotRadius * 2.5)
			
			NSGraphicsContext.saveGraphicsState()
			
			let shadow = NSShadow()
			shadow.shadowOffset = NSSize(width: 0, height: -1)
			shadow.shadowBlurRadius = edgeLength/20
			shadow.set()
			
			NSColor.white.set()
			NSBezierPath(roundedRect: dieFrame, xRadius: cornerRadius, yRadius: cornerRadius).fill()
			
			NSGraphicsContext.restoreGraphicsState()
			
			NSColor.black.set()
			
			func drawDot(_ u: CGFloat, _ v: CGFloat) {
				let dotOrigin = CGPoint(x: dotFrame.minX + dotFrame.width * u,
										y: dotFrame.minY + dotFrame.height * v)
				let dotRect = CGRect(origin: dotOrigin, size: CGSize.zero)
					.insetBy(dx: -dotRadius, dy: -dotRadius)
				NSBezierPath(ovalIn: dotRect).fill()
			}
			
			if (1...6).firstIndex(of: intValue) != nil {
				// Draw Dots
				if [1, 3, 5].firstIndex(of: intValue) != nil {
					drawDot(0.5, 0.5) // center dot
				}
				if (2...6).firstIndex(of: intValue) != nil {
					drawDot(0, 1) // upper left
					drawDot(1, 0) // lower right
				}
				if (4...6).firstIndex(of: intValue) != nil {
					drawDot(1, 1) // upper right
					drawDot(0, 0) // lower left
				}
				if intValue == 6 {
					drawDot(0, 0.5) // mid left/right
					drawDot(1, 0.5)
				}
			}
		}
	}
	
}
