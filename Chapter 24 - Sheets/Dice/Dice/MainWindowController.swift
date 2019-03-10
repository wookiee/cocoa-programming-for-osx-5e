//
//  MainWindowController.swift
//  Dice
//
//  Created by Adam Preble on 8/22/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {

	override var windowNibName: String! {
		return "MainWindowController"
	}
	
    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    // MARK: - Actions

    var configurationWindowController: ConfigurationWindowController?
    
    @IBAction func showDieConfiguration(_ sender: AnyObject?) {
        if let window = window, let dieView = window.firstResponder as? DieView {
            let windowController = ConfigurationWindowController()
            windowController.configuration = DieConfiguration(color: dieView.color,
                rolls: dieView.numberOfTimesToRoll)
            
            window.beginSheet(windowController.window!, completionHandler: { response in
                
                if response == NSApplication.ModalResponse.OK {
                    let configuration = self.configurationWindowController!.configuration
                    
                    dieView.color = configuration.color
                    dieView.numberOfTimesToRoll = configuration.rolls
                }
                self.configurationWindowController = nil
            })
            configurationWindowController = windowController
        }
    }
    
}
