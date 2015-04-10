//
//  AppDelegate.swift
//  Random
//
//  Created by Adam Preble on 10/8/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var textField: NSTextField!

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        let now = NSDate()
        textField.objectValue = now
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    @IBAction func seed(sender: AnyObject) {
        // Seed the random number generator with the time
        srandom(UInt32(time(nil)))
        textField.stringValue = "Generator Seeded"
    }
    
    @IBAction func generate(sender: AnyObject) {
        // Generate a number between 1 and 100 inclusive
        let generated = (random() % 100) + 1
        println("generated = \(generated)")
        textField.integerValue = generated
    }

}

