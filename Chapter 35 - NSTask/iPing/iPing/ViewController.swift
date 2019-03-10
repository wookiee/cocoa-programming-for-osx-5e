//
//  ViewController.swift
//  iPing
//
//  Created by Juan Pablo Claude on 2/25/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet var outputView: NSTextView!
    @IBOutlet weak var hostField: NSTextField!
    @IBOutlet weak var startButton: NSButton!
    var task: Process?
    var pipe: Pipe?
    var fileHandle: FileHandle?
    
    @IBAction func togglePinging(_ sender: NSButton) {
        // Is there a running task?
        if let task = task {
            // If there is, stop it!
            task.interrupt()
        } else {
            // If there isn't, start one.
        
            // Create a new task
            let task = Process()
            task.launchPath = "/sbin/ping"
            task.arguments = ["-c10", hostField.stringValue]
        
            // Create a new pipe for standardOutput
            let pipe = Pipe()
            task.standardOutput = pipe
        
            // Grab the file handle
            let fileHandle = pipe.fileHandleForReading
        
            self.task = task
            self.pipe = pipe
            self.fileHandle = fileHandle
        
            let notificationCenter = NotificationCenter.default
            notificationCenter.removeObserver(self)
            notificationCenter.addObserver(self,
                                 selector: #selector(ViewController.receiveDataReadyNotification(_:)),
                                     name: FileHandle.readCompletionNotification,
                                   object: fileHandle)
            notificationCenter.addObserver(self,
                                 selector: #selector(ViewController.receiveTaskTerminatedNotification(_:)),
                                     name: Process.didTerminateNotification,
                                   object: task)
        
            task.launch()
        
            outputView.string = ""
        
            fileHandle.readInBackgroundAndNotify()
        }
        
    }
    
    
    func appendData(_ data: Data) {
        let string = String(data: data, encoding: String.Encoding.utf8)! as String
        let textStorage = outputView.textStorage!
        let endRange = NSRange(location: textStorage.length, length: 0)
        textStorage.replaceCharacters(in: endRange, with: string)
    }
    
    
    @objc func receiveDataReadyNotification(_ notification: Notification) {
        let data = notification.userInfo![NSFileHandleNotificationDataItem] as! Data
        let length = data.count
                
        print("received data: \(length) bytes")
        if length > 0 {
            self.appendData(data)
        }
                
        // If the task is running, start reading again
        if let fileHandle = fileHandle {
            fileHandle.readInBackgroundAndNotify()
        }
    }
    
    
    @objc func receiveTaskTerminatedNotification(_ notification: Notification) {
        print("task terminated")
                
        task = nil
        pipe = nil
        fileHandle = nil
                
        startButton.state = convertToNSControlStateValue(0)
    }

}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSControlStateValue(_ input: Int) -> NSControl.StateValue {
	return NSControl.StateValue(rawValue: input)
}
