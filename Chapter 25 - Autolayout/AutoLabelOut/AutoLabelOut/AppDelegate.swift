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

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        //Create the controls for the window:
        
        //Create a label:
        let label = NSTextField(frame: NSRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.stringValue = "Label"
        
        //Give this NSTextField the styling of a label:
        label.backgroundColor = NSColor.clear
        label.isEditable = false
        label.isSelectable = false
        label.isBezeled = false
        
        //Create a text field:
        let textField = NSTextField(frame: NSRect.zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        //Make the text field update the label's text
        
        // when the text field's text changes:
        textField.action = #selector(NSCell.takeStringValueFrom(_:))
        textField.target = label
        let superview = window.contentView!
        superview.addSubview(label)
        superview.addSubview(textField)
        
        //Create the constraints between the controls:
        let horizontalConstraints =
        NSLayoutConstraint.constraints(withVisualFormat: "|-[label]-[textField(>=100)]-|",
            options:.alignAllLastBaseline,
            metrics:nil,
            views: ["label" : label, "textField" : textField])
        NSLayoutConstraint.activate(horizontalConstraints)
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[textField]-|",
            options:[],
            metrics:nil,
            views: ["textField" : textField])
        NSLayoutConstraint.activate(verticalConstraints)
        
//        window.visualizeConstraints(superview.constraints)
        superview.updateConstraintsForSubtreeIfNeeded()
        if superview.hasAmbiguousLayout {
            superview.exerciseAmbiguityInLayout()
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

