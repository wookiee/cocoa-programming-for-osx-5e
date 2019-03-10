//
//  CourseListViewController.swift
//  RanchForecastSplit
//
//  Created by Juan Pablo Claude on 2/20/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

import Cocoa

protocol CourseListViewControllerDelegate: class {
    func courseListViewController(_ viewController: CourseListViewController,
                                  selectedCourse: Course?) -> Void
}


class CourseListViewController: NSViewController {
    
    weak var delegate: CourseListViewControllerDelegate? = nil
    
    @objc dynamic var courses: [Course] = []
    
    let fetcher = ScheduleFetcher()
    
    @IBOutlet var arrayController: NSArrayController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetcher.fetchCoursesUsingCompletionHandler { (result) in
            switch result {
                case .success(let courses):
                    #if DEBUG
                        print("Got courses: \(courses)")
                    #else
                        print("Got courses")
                    #endif
                    self.courses = courses
                case .failure(let error):
                    print("Got error: \(error)")
                    NSAlert(error: error).runModal()
                    self.courses = []
            }
        }
    }
    
    
    @IBAction func selectCourse(_ sender: AnyObject) {
        let selectedCourse = arrayController.selectedObjects.first as! Course?
        delegate?.courseListViewController(self, selectedCourse: selectedCourse)
    }

}
