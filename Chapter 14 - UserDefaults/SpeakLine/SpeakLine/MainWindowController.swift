//
//  MainWindowController.swift
//  SpeakLine
//
//  Created by Juan Pablo Claude on 2/20/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController, NSSpeechSynthesizerDelegate, NSWindowDelegate, NSTableViewDataSource, NSTableViewDelegate {

    override var windowNibName: String {
        return "MainWindowController"
    }
    
    
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var speakButton: NSButton!
    @IBOutlet weak var stopButton: NSButton!
    @IBOutlet weak var tableView: NSTableView!
    
    let preferenceManager = PreferenceManager()
    let speechSynth: NSSpeechSynthesizer = NSSpeechSynthesizer()
    
    let voices = NSSpeechSynthesizer.availableVoices() as! [String]
    
    var isStarted: Bool = false {
        didSet {
        updateButtons()
        }
    }
    
    
    override func windowDidLoad() {
        super.windowDidLoad()
        updateButtons()
        speechSynth.delegate = self
        let defaultVoice = preferenceManager.activeVoice!
        if let defaultRow = find(voices, defaultVoice) {
            let indices = NSIndexSet(index: defaultRow)
            tableView.selectRowIndexes(indices, byExtendingSelection: false)
            tableView.scrollRowToVisible(defaultRow)
        }
        textField.stringValue = preferenceManager.activeText!
    }
    
    
    // MARK: Action methods
    @IBAction func speakIt(sender: NSButton) {
            
        // Get typed-in text as a string
        let string = textField.stringValue
        if string.isEmpty {
            println("string from \(textField) is empty")
        } else {
            speechSynth.startSpeakingString(string)
            isStarted = true
        }
    }
    
    
    @IBAction func stopIt(sender: NSButton) {
        speechSynth.stopSpeaking()
        //isStarted = false
    }
    
    
    func updateButtons() {
        if isStarted {
            speakButton.enabled = false
            stopButton.enabled = true
        } else {
            stopButton.enabled = false
            speakButton.enabled = true
        }
    }
    
    
    // MARK: NSSpeechSynthesizerDelegate
    func speechSynthesizer(sender: NSSpeechSynthesizer, didFinishSpeaking finishedSpeaking: Bool) {
        isStarted = false
        println("finishedSpeaking=\(finishedSpeaking)")
    }
    
    
    // MARK: NSWindowDelegate
    func windowShouldClose(sender: AnyObject) -> Bool {
        return !isStarted
    }
    

    // MARK: NSTableViewDataSource
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return voices.count
    }
    
 
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        let voice = voices[row]
        if let attributes = NSSpeechSynthesizer.attributesForVoice(voice) {
            return attributes[NSVoiceName]
        } else {
            return nil
        }
    }
    
    
    // MARK: NSTableViewDelegate
    func tableViewSelectionDidChange(notification: NSNotification) {
        let row = tableView.selectedRow
            
        // Set the voice back to the default if the user has deselected all rows
        if row == -1 {
            speechSynth.setVoice(nil)
        return
        }
        let voice = voices[row]
        speechSynth.setVoice(voice)
        preferenceManager.activeVoice = voice
    }
    
    
    // MARK: - NSTextFieldDelegate
    override func controlTextDidChange(obj: NSNotification) {
        preferenceManager.activeText = textField.stringValue
    }
    
}
