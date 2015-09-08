//
//  MainWindowController.swift
//  Thermostat
//
//  Created by Susan on 2/25/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
    
    override var windowNibName: String? {
        return "MainWindowController"
    }

    var internalTemperature = 68
    dynamic var temperature: Int {
        set {
            print("set temperature to \(newValue)")
            internalTemperature = newValue
        }
        get {
            print("get temperature")
            return internalTemperature
        }
    }
    dynamic var isOn = true
    
    @IBAction func makeWarmer(sender: NSButton) {
        willChangeValueForKey("temperature")
        temperature++
        didChangeValueForKey("temperature")
    }
    
    @IBAction func makeCooler(sender: NSButton) {
        temperature--
    }
    
    @IBAction func updateSwitch(sender: NSButton) {
        if isOn {
            isOn = false
        } else {
            isOn = true
        }
    }

}
