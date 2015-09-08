//
//  Document.swift
//  ZIPspector
//
//  Created by Juan Pablo Claude on 2/25/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

import Cocoa

class Document: NSDocument, NSTableViewDataSource {
    
    @IBOutlet weak var tableView: NSTableView!
    
    var filenames: [String] = []
    

    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }

    
    override func windowControllerDidLoadNib(aController: NSWindowController) {
        super.windowControllerDidLoadNib(aController)
        // Add any code here that needs to be executed once the windowController has loaded the document's window.
    }

    
    override class func autosavesInPlace() -> Bool {
        return true
    }

    
    override var windowNibName: String? {
        // Returns the nib file name of the document
        // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this property and override -makeWindowControllers instead.
        return "Document"
    }
    
    override func readFromURL(url: NSURL, ofType typeName: String) throws {
        // Which file are we getting the zipinfo for?
        let filename = url.path!
        
        // Prepare a task object
        let task = NSTask()
        task.launchPath = "/usr/bin/zipinfo"
        task.arguments = ["-1", filename]
        
        // Create the pipe to read from
        let outPipe = NSPipe()
        task.standardOutput = outPipe
        
        // Start the process
        task.launch()
        
        // Read the output
        let fileHandle = outPipe.fileHandleForReading
        let data = fileHandle.readDataToEndOfFile()
        
        // Make sure the task terminates normally
        task.waitUntilExit()
        let status = task.terminationStatus
        
        // Check status
        guard status == 0 else {
            let errorDomain = "com.bignerdranch.ProcessReturnCodeErrorDomain"
            let errorInfo
                = [ NSLocalizedFailureReasonErrorKey : "zipinfo returned \(status)"]
            let error = NSError(domain: errorDomain,
                                  code: 0,
                              userInfo: errorInfo)
            throw error
        }
        
        // Convert to a string
        let string = String(data: data, encoding: NSUTF8StringEncoding)!
        
        // Break the string into lines
        filenames = string.componentsSeparatedByString("\n")
        print("filenames = \(filenames)")
        
        // In case of revert
        tableView?.reloadData()
    }
        
        
    
    
    // MARK: - NSTableViewDataSource
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return filenames.count
    }
    
    
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        return filenames[row]
    }


}

