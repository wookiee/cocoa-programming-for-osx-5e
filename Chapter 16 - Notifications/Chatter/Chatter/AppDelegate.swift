//
//  AppDelegate.swift
//  Chatter
//
//  Created by Juan Pablo Claude on 2/23/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var windowControllers: [ChatWindowController] = []


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        addWindowController()
    }

    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    
    // MARK: - Actions
    @IBAction func displayNewWindow(_ sender: NSMenuItem) {
        addWindowController()
    }
    
    
    // MARK: - Helpers
    func addWindowController() {
        let windowController = ChatWindowController()
        windowController.showWindow(self)
        windowControllers.append(windowController)
    }
    

}

