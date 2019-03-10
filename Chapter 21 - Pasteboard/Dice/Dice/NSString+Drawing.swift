//
//  NSString+Drawing.swift
//  Dice
//
//  Created by Adam Preble on 8/24/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

import Cocoa

extension NSString {

    func drawCenteredInRect(_ rect: NSRect, attributes: [String: AnyObject]?) {
        let stringSize = size(withAttributes: convertToOptionalNSAttributedStringKeyDictionary(attributes))
        let stringOrigin = NSPoint(x: rect.origin.x + (rect.width - stringSize.width)/2.0,
                                   y: rect.origin.y + (rect.height - stringSize.height)/2.0)
        draw(at: stringOrigin, withAttributes: convertToOptionalNSAttributedStringKeyDictionary(attributes))
    }

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
