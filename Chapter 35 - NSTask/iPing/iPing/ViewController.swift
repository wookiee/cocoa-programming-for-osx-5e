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
    var task: NSTask?
    var pipe: NSPipe?
    var fileHandle: NSFileHandle?
    
    @IBAction func togglePinging(sender: NSButton) {
        // Is there a running task?
        if let task = task {
            // If there is, stop it!
            task.interrupt()
        } else {
            // If there isn't, start one.
        
            // Create a new task
            let task = NSTask()
            task.launchPath = "/sbin/ping"
            task.arguments = ["-c10", hostField.stringValue]
        
            // Create a new pipe for standardOutput
            let pipe = NSPipe()
            task.standardOutput = pipe
        
            // Grab the file handle
            let fileHandle = pipe.fileHandleForReading
        
            self.task = task
            self.pipe = pipe
            self.fileHandle = fileHandle
        
            let notificationCenter = NSNotificationCenter.defaultCenter()
            notificationCenter.removeObserver(self)
            notificationCenter.addObserver(self,
                                 selector: Selector("receiveDataReadyNotification:"),
                                     name: NSFileHandleReadCompletionNotification,
                                   object: fileHandle)
            notificationCenter.addObserver(self,
                                 selector: Selector("receiveTaskTerminatedNotification:"),
                                     name: NSTaskDidTerminateNotification,
                                   object: task)
        
            task.launch()
        
            outputView.string = ""
        
            fileHandle.readInBackgroundAndNotify()
        }
        
    }
    
    
    func appendData(data: NSData) {
        let string = String(data: data, encoding: NSUTF8StringEncoding)! as String
        let textStorage = outputView.textStorage!
        let endRange = NSRange(location: textStorage.length, length: 0)
        textStorage.replaceCharactersInRange(endRange, withString: string)
    }
    
    
    func receiveDataReadyNotification(notification: NSNotification) {
        let data = notification.userInfo![NSFileHandleNotificationDataItem] as! NSData
        let length = data.length
                
        print("received data: \(length) bytes")
        if length > 0 {
            self.appendData(data)
        }
                
        // If the task is running, start reading again
        if let fileHandle = fileHandle {
            fileHandle.readInBackgroundAndNotify()
        }
    }
    
    
    func receiveTaskTerminatedNotification(notification: NSNotification) {
        print("task terminated")
                
        task = nil
        pipe = nil
        fileHandle = nil
                
        startButton.state = 0
    }

}

