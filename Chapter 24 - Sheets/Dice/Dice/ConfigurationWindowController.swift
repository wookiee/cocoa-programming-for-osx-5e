//
//  PreferenceWindowController.swift
//  Dice
//
//  Created by Nate Chandler on 10/15/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

import Cocoa

struct DieConfiguration {
    let color: NSColor
    let rolls: Int
}

class ConfigurationWindowController: NSWindowController {

    var configuration: DieConfiguration {
        set {
            color = newValue.color
            rolls = newValue.rolls
        }
        get {
            return DieConfiguration(color: color, rolls: rolls)
        }
    }
    
    private dynamic var color: NSColor = NSColor.whiteColor()
    private dynamic var rolls: Int = 10
    
    override var windowNibName: String {
        get {
            return "ConfigurationWindowController"
        }
    }
    
    @IBAction func okayButtonClicked(button: NSButton) {
        dismissWithModalResponse(NSModalResponseOK)
    }
    
    @IBAction func cancelButtonClicked(button: NSButton) {
        dismissWithModalResponse(NSModalResponseCancel)
    }
    
    func dismissWithModalResponse(response: NSModalResponse) {
        window!.sheetParent!.endSheet(window!, returnCode: response)
    }
    
}
