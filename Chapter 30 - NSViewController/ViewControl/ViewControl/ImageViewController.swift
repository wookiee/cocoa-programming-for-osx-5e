//
//  ImageViewController.swift
//  ViewControl
//
//  Created by Juan Pablo Claude on 2/17/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

import Cocoa

class ImageViewController: NSViewController {
    
    @objc var image: NSImage?
    
    
    override var nibName: String? {
        return "ImageViewController"
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
