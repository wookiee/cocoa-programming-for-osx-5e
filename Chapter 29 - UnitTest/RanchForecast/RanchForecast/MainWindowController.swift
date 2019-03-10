//
//  MainWindowController.swift
//  RanchForecast
//
//  Created by Juan Pablo Claude on 2/16/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
    
    @IBOutlet var tableView: NSTableView!
    @IBOutlet var arrayController: NSArrayController!
    
    let fetcher = ScheduleFetcher()
    @objc dynamic var courses: [Course] = []
    
    
    override var windowNibName: String! {
        return "MainWindowController"
    }
    

    override func windowDidLoad() {
        super.windowDidLoad()
        
        tableView.target = self
        tableView.doubleAction = #selector(MainWindowController.openClass(_:))
        
        fetcher.fetchCoursesUsingCompletionHandler { (result) in switch result {
            case .success(let courses):
                print("Got courses: \(courses)")
                self.courses = courses
            case .failure(let error):
                print("Got error: \(error)")
                NSAlert(error: error).runModal()
                self.courses = []
            }
        }
    }
    
    
    @objc func openClass(_ sender: AnyObject!) {
        if let course = arrayController.selectedObjects.first as? Course {
            NSWorkspace.shared.open(course.url as URL)
        }
    }
    
}
