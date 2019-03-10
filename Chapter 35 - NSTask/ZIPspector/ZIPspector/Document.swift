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

    
    override func windowControllerDidLoadNib(_ aController: NSWindowController) {
        super.windowControllerDidLoadNib(aController)
        // Add any code here that needs to be executed once the windowController has loaded the document's window.
    }

    
    override class var autosavesInPlace: Bool {
        return true
    }

    
    override var windowNibName: String? {
        // Returns the nib file name of the document
        // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this property and override -makeWindowControllers instead.
        return "Document"
    }
    
    override func read(from url: URL, ofType typeName: String) throws {
        // Which file are we getting the zipinfo for?
        let filename = url.path
        
        // Prepare a task object
        let task = Process()
        task.launchPath = "/usr/bin/zipinfo"
        task.arguments = ["-1", filename]
        
        // Create the pipe to read from
        let outPipe = Pipe()
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
        let string = String(data: data, encoding: String.Encoding.utf8)!
        
        // Break the string into lines
        filenames = string.components(separatedBy: "\n")
        Swift.print("filenames = \(filenames)")
        // In case of revert
        tableView?.reloadData()
    }
        
        
    
    
    // MARK: - NSTableViewDataSource
    func numberOfRows(in tableView: NSTableView) -> Int {
        return filenames.count
    }
    
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return "\(filenames[row])"
    }


}

