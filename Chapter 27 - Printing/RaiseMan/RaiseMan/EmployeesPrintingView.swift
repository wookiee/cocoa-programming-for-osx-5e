//
//  EmployeesPrintingView.swift
//  RaiseMan
//
//  Created by Nicholas Teissler on 3/9/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

import Cocoa

private let font: NSFont = NSFont.userFixedPitchFont(ofSize: 12.0)!
private let textAttributes: [String: AnyObject] = [convertFromNSAttributedStringKey(NSAttributedString.Key.font) : font]
private let lineHeight: CGFloat = font.capHeight * 2.0

class EmployeesPrintingView: NSView {
    
    let employees: [Employee]

    var pageRect = NSRect()
    var linesPerPage: Int = 0
    var currentPage: Int = 0
    
    // MARK: - Lifecycle
    
    init(employees: [Employee]) {
        self.employees = employees
        super.init(frame: NSRect())
    }

    required init?(coder: NSCoder) {
        fatalError("unimplemented: instantiate programmatically instead")
    }
    
    // MARK: - Pagination
    
    override func knowsPageRange(_ range: NSRangePointer) -> Bool {
        let printOperation = NSPrintOperation.current!
        let printInfo: NSPrintInfo = printOperation.printInfo
        
        // Where can I draw?
        pageRect = printInfo.imageablePageBounds
        let newFrame = NSRect(origin: CGPoint(), size: printInfo.paperSize)
        frame = newFrame
        
        // How many lines per page?
        linesPerPage = Int(pageRect.height / lineHeight)
        
        // Construct the range to return 
        var rangeOut = NSRange(location: 0, length: 0)
        
        // Pages are 1-based. That is, the first page is 1. 
        rangeOut.location = 1
        
        // How many pages will it take?
        rangeOut.length = employees.count / linesPerPage
        if employees.count % linesPerPage > 0 {
            rangeOut.length += 1
        }
        
        // Return the newly constructed range, rangeOut, via the range pointer
        range.pointee = rangeOut
        
        return true
    }
    
    override func rectForPage(_ page: Int) -> NSRect {
        // Note the current page
        // Although Cocoa uses 1=based indexing for the page number
        //  it's easier not to do that here.
        currentPage = page - 1
        
        // Return the same page every time
        return pageRect
    }
    
    // MARK: - Drawing
    
    // The origin of the view is at the upper left corner
    override var isFlipped: Bool {
        return true
    }
    
    override func draw(_ dirtyRect: NSRect) {
        var nameRect = NSRect(x: pageRect.minX,
                              y: 0,
                          width: 200.0,
                         height: lineHeight)
        var raiseRect = NSRect(x: nameRect.maxX,
                               y: 0,
                           width: 100.0,
                          height: lineHeight)   
        
        for indexOnPage in 0..<linesPerPage {
            let indexInEmployees = currentPage * linesPerPage + indexOnPage
            if indexInEmployees >= employees.count {
                break
            }
            
            let employee = employees[indexInEmployees]
            
            // Draw index and name
            nameRect.origin.y = pageRect.minY + CGFloat(indexOnPage) * lineHeight
            let employeeName = (employee.name ?? "")
            let indexAndName = "\(indexInEmployees) \(employeeName)"
            indexAndName.draw(in: nameRect, withAttributes: convertToOptionalNSAttributedStringKeyDictionary(textAttributes))
            // Draw raise
            raiseRect.origin.y = nameRect.minY
            let raise = String(format: "%4.1f%%", employee.raise * 100)
            let raiseString = raise
            raiseString.draw(in: raiseRect, withAttributes: convertToOptionalNSAttributedStringKeyDictionary(textAttributes))
        }
    }
}

fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
