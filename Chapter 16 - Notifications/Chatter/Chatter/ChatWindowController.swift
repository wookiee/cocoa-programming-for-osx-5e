//
//  ChatWindowController.swift
//  Chatter
//
//  Created by Juan Pablo Claude on 2/23/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

import Cocoa

private let ChatWindowControllerDidSendMessageNotification = "com.bignerdranch.chatter.ChatWindowControllerDidSendMessageNotification"
private let ChatWindowControllerMessageKey = "com.bignerdranch.chatter.ChatWindowControllerMessageKey"


class ChatWindowController: NSWindowController {
    
    @objc dynamic var log: NSAttributedString = NSAttributedString(string: "")
    @objc dynamic var message: String?
    
    // NSTextView does not support weak references.
    @IBOutlet var textView: NSTextView!
    
    
    override var windowNibName: String {
        return "ChatWindowController"
    }
    

    override func windowDidLoad() {
        super.windowDidLoad()

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(ChatWindowController.receiveDidSendMessageNotification(_:)),
                                       name: NSNotification.Name(rawValue: ChatWindowControllerDidSendMessageNotification),
                                       object: nil)
    }
    
    
    deinit {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }
    
    
    // MARK: - Actions
    @IBAction func send(_ sender: NSButton) {
        sender.window?.endEditing(for: nil)
        if let message = message {
            let userInfo = [ChatWindowControllerMessageKey : message]
            let notificationCenter = NotificationCenter.default
            notificationCenter.post(name: Notification.Name(rawValue: ChatWindowControllerDidSendMessageNotification),
                                                    object: self,
                                                  userInfo: userInfo)
        }
        message = ""
    }
    
    
    // MARK: - Notifications
    // ChatWindowControllerDidSendMessageNotification
    @objc func receiveDidSendMessageNotification(_ note: Notification) {
        let mutableLog = log.mutableCopy() as! NSMutableAttributedString
                                        
        if log.length > 0 {
            mutableLog.append(NSAttributedString(string: "\n"))
        }
        
        let userInfo = note.userInfo! as! [String : String]
        let message = userInfo[ChatWindowControllerMessageKey]!
                                        
        let logLine = NSAttributedString(string: message)
        mutableLog.append(logLine)
        
        log = mutableLog.copy() as! NSAttributedString
        
        textView.scrollRangeToVisible(NSRange(location: log.length, length: 0))
    }
    
}
