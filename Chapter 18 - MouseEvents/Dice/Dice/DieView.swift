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

	var pressed: Bool = false {
		didSet {
			needsDisplay = true
		}
	}

	func randomize() {
		intValue = Int(arc4random_uniform(5) + 1)
	}
	
	override var intrinsicContentSize: NSSize {
		return NSSize(width: 20, height: 20)
	}

	override func drawRect(dirtyRect: NSRect) {
		let backgroundColor = NSColor.lightGrayColor()
		backgroundColor.set()
		NSBezierPath.fillRect(bounds)
		
		drawDieWithSize(bounds.size)
	}
	
	func metricsForSize(size: CGSize) -> (edgeLength: CGFloat, dieFrame: CGRect) {
		let edgeLength = min(size.width, size.height)
		let padding = edgeLength/10.0
		let drawingBounds = CGRect(x: 0, y: 0, width: edgeLength, height: edgeLength)
		var dieFrame = drawingBounds.insetBy(dx: padding, dy: padding)
		if pressed {
			dieFrame = dieFrame.offsetBy(dx: 0, dy: -edgeLength/40)
		}
		return (edgeLength, dieFrame)
	}
	
	func drawDieWithSize(size: CGSize) {
		if let intValue = intValue {
			let (edgeLength, dieFrame) = metricsForSize(size)
			let cornerRadius:CGFloat = edgeLength/5.0
			let dotRadius = edgeLength/12.0
			let dotFrame = dieFrame.insetBy(dx: dotRadius * 2.5, dy: dotRadius * 2.5)
			
			NSGraphicsContext.saveGraphicsState()
			
			let shadow = NSShadow()
			shadow.shadowOffset = NSSize(width: 0, height: -1)
			shadow.shadowBlurRadius = (pressed ? edgeLength/100 : edgeLength/20)
			shadow.set()
			
			NSColor.whiteColor().set()
			NSBezierPath(roundedRect: dieFrame, xRadius: cornerRadius, yRadius: cornerRadius).fill()
			
			NSGraphicsContext.restoreGraphicsState()
			
			NSColor.blackColor().set()
			
			func drawDot(u: CGFloat, _ v: CGFloat) {
				let dotOrigin = CGPoint(x: dotFrame.minX + dotFrame.width * u,
										y: dotFrame.minY + dotFrame.height * v)
				let dotRect = CGRect(origin: dotOrigin, size: CGSizeZero)
					.insetBy(dx: -dotRadius, dy: -dotRadius)
				NSBezierPath(ovalInRect: dotRect).fill()
			}
			
			if (1...6).indexOf(intValue) != nil {
				// Draw Dots
				if [1, 3, 5].indexOf(intValue) != nil {
					drawDot(0.5, 0.5) // center dot
				}
				if (2...6).indexOf(intValue) != nil {
					drawDot(0, 1) // upper left
					drawDot(1, 0) // lower right
				}
				if (4...6).indexOf(intValue) != nil {
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
	
	// MARK: - Mouse Events
	
	override func mouseDown(theEvent: NSEvent) {
		Swift.print("mouseDown")
		let dieFrame = metricsForSize(bounds.size).dieFrame
		let pointInView = convertPoint(theEvent.locationInWindow, fromView: nil)
		pressed = dieFrame.contains(pointInView)
	}
	override func mouseDragged(theEvent: NSEvent) {
		Swift.print("mouseDragged location: \(theEvent.locationInWindow)")
	}
	override func mouseUp(theEvent: NSEvent) {
		Swift.print("mouseUp clickCount: \(theEvent.clickCount)")
		if theEvent.clickCount == 2 && pressed {
			randomize()
		}
		pressed = false
	}
	
}
