//
//  AppDelegate.swift
//  AutoLabelOut
//
//  Created by Nicholas Teissler on 2/24/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        
        //Create the controls for the window:
        
        //Create a label:
        let label = NSTextField(frame: NSRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.stringValue = "Label"
        
        //Give this NSTextField the styling of a label:
        label.backgroundColor = NSColor.clearColor()
        label.editable = false
        label.selectable = false
        label.bezeled = false
        
        //Create a text field:
        let textField = NSTextField(frame: NSRect.zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        //Make the text field update the label's text
        
        // when the text field's text changes:
        textField.action = Selector("takeStringValueFrom:")
        textField.target = label
        let superview = window.contentView!
        superview.addSubview(label)
        superview.addSubview(textField)
        
        //Create the constraints between the controls:
        let horizontalConstraints =
        NSLayoutConstraint.constraintsWithVisualFormat("|-[label]-[textField(>=100)]-|",
            options:.AlignAllBaseline,
            metrics:nil,
            views: ["label" : label, "textField" : textField])
        NSLayoutConstraint.activateConstraints(horizontalConstraints)
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[textField]-|",
            options:[],
            metrics:nil,
            views: ["textField" : textField])
        NSLayoutConstraint.activateConstraints(verticalConstraints)
        
//        window.visualizeConstraints(superview.constraints)
        superview.updateConstraintsForSubtreeIfNeeded()
        if superview.hasAmbiguousLayout {
            superview.exerciseAmbiguityInLayout()
        }
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

