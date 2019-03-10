//
//  Document.swift
//  RaiseMan
//
//  Created by Nate Chandler on 9/1/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

import Cocoa

private var KVOContext: Int = 0

class Document: NSDocument, NSWindowDelegate {
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var arrayController: NSArrayController!
    @objc var employees: [Employee] = [] {
        willSet {
            for employee in employees {
                stopObservingEmployee(employee)
            }
        }
        didSet {
            for employee in employees {
                startObservingEmployee(employee)
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func addEmployee(_ sender: NSButton) {
        let windowController = windowControllers[0]
        let window = windowController.window!
        
        let endedEditing = window.makeFirstResponder(window)
        if !endedEditing {
            Swift.print("Unable to end editing")
            return
        }
        
        let undo: UndoManager = undoManager!
        
        // Has an edit occurred already in this event?
        if undo.groupingLevel > 0 {
            // Close the last group
            undo.endUndoGrouping()
            // Open a new group
            undo.beginUndoGrouping()
        }
        
        // Create the object
        let employee = arrayController.newObject() as! Employee
        
        // Add it to the array controller's content array
        arrayController.addObject(employee)
        
        // Re-sort (in case the use has sorted a column) 
        arrayController.rearrangeObjects()
        
        // Get the sorted array
        let sortedEmployees = arrayController.arrangedObjects as! [Employee]
        
        // Find the object just added
        let row = sortedEmployees.firstIndex(of: employee)!
        
        // Begin the edit in the first column
        Swift.print("starting edit of \(employee) in row \(row)")
        tableView.editColumn(0, row: row, with: nil, select: true)
    }
    
    // MARK: - Accessors
    
    @objc func insertObject(_ employee: Employee, inEmployeesAtIndex index: Int) {
        Swift.print("adding \(employee) to the employees array")
        
        // Add the inverse of this operation to the undo stack
        let undo: UndoManager = undoManager!
        (undo.prepare(withInvocationTarget: self) as AnyObject).removeObjectFromEmployeesAtIndex(employees.count)
        if !undo.isUndoing {
            undo.setActionName("Add Person")
        }
        
        employees.append(employee)
    }
    
    @objc func removeObjectFromEmployeesAtIndex(_ index: Int) {
        let employee: Employee = employees[index]
        
        Swift.print("removing \(employee) from the employees array")
        
        // Add the inverse of this operation to the undo stack 
        let undo: UndoManager = undoManager!
        (undo.prepare(withInvocationTarget: self) as AnyObject).insertObject(employee, inEmployeesAtIndex: index)
        if !undo.isUndoing {
            undo.setActionName("Remove Person")
        }
        
        // Remove the employee from the array
        employees.remove(at: index)
    }
    
    // MARK: - Key Value Observing
    
    func startObservingEmployee(_ employee: Employee) {
        employee.addObserver(self, forKeyPath: "name", options: .old, context: &KVOContext)
        employee.addObserver(self, forKeyPath: "raise", options: .old, context: &KVOContext)
    }
    
    func stopObservingEmployee(_ employee: Employee) {
        employee.removeObserver(self, forKeyPath: "name", context: &KVOContext)
        employee.removeObserver(self, forKeyPath: "raise", context: &KVOContext)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard context == &KVOContext else {
            // If the context does not match, this message
            // must be intended for our superclass.
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        if let keyPath = keyPath, let object = object, let change = change {
            var oldValue: AnyObject? = change[NSKeyValueChangeKey.oldKey] as AnyObject
            if oldValue is NSNull {
                oldValue = nil
            }
            
            let undo: UndoManager = undoManager!
            Swift.print("oldValue=\(String(describing: oldValue))")
            (undo.prepare(withInvocationTarget: object) as AnyObject).setValue(oldValue, forKeyPath: keyPath)
        }
    }
    
    // MARK - Lifecycle
    
    override init() {
        super.init()
        // Add your subclass-specific initialization here.
                                    
    }

    // MARK - NSDocument Overrides
    
    override func windowControllerDidLoadNib(_ aController: NSWindowController) {
        super.windowControllerDidLoadNib(aController)
                                    
        // Add any code here that needs to be executed once the windowController has loaded the document's window.
    }

    override class var autosavesInPlace: Bool {
        return true
    }

    override var windowNibName: String {
        // Returns the nib file name of the document
        // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this property and override -makeWindowControllers instead.
        return "Document"
    }

    override func data(ofType typeName: String?) throws -> Data {
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }

    override func read(from data: Data, ofType typeName: String?) throws {
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }

    // MARK: - NSWindowDelegate
    
    func windowWillClose(_ notification: Notification) {
        employees = []
    }
}

