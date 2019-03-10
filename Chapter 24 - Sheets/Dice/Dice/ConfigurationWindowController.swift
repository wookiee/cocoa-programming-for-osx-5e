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
    
    @objc fileprivate dynamic var color: NSColor = NSColor.white
    @objc fileprivate dynamic var rolls: Int = 10
    
    override var windowNibName: String {
        get {
            return "ConfigurationWindowController"
        }
    }
    
    @IBAction func okayButtonClicked(_ button: NSButton) {
        dismissWithModalResponse(NSApplication.ModalResponse.OK)
    }
    
    @IBAction func cancelButtonClicked(_ button: NSButton) {
        dismissWithModalResponse(NSApplication.ModalResponse.cancel)
    }
    
    func dismissWithModalResponse(_ response: NSApplication.ModalResponse) {
        window!.sheetParent!.endSheet(window!, returnCode: response)
    }
    
}
