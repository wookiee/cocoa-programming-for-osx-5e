//
//  MainWindowController.swift
//  RGBWell
//
//  Created by Susan on 12/29/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
    
    @IBOutlet weak var rSlider: NSSlider!
    @IBOutlet weak var gSlider: NSSlider!
    @IBOutlet weak var bSlider: NSSlider!
    @IBOutlet weak var colorWell: NSColorWell!
    
    override var windowNibName: String {
        return "MainWindowController"
    }
    
    var r: Float = 0.5
    var g: Float = 0.5
    var b: Float = 0.5
    
    let a = 1.0

    override func windowDidLoad() {
        super.windowDidLoad()
        rSlider.floatValue = r
        gSlider.floatValue = g
        bSlider.floatValue = b
        adjustColor()
    }
    
    @IBAction func adjustRed(_ sender: NSSlider) {
        r = sender.floatValue
        adjustColor()
    }
    
    @IBAction func adjustGreen(_ sender: NSSlider) {
        g = sender.floatValue
        adjustColor()
    }
    
    @IBAction func adjustBlue(_ sender: NSSlider) {
        b = sender.floatValue
        adjustColor()
    }
    
    func adjustColor() {
        let newColor = NSColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: CGFloat(a))
    
        colorWell.color = newColor
    }
    
}
