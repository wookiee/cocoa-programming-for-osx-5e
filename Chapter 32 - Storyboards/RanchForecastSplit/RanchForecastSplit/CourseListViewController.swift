//
//  CourseListViewController.swift
//  RanchForecastSplit
//
//  Created by Juan Pablo Claude on 2/20/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

import Cocoa


protocol CourseListViewControllerDelegate: class {
    func courseListViewController(viewController: CourseListViewController,
                                  selectedCourse: Course?) -> Void
}


class CourseListViewController: NSViewController {
    
    weak var delegate: CourseListViewControllerDelegate? = nil
    
    dynamic var courses: [Course] = []
    
    let fetcher = ScheduleFetcher()
    
    @IBOutlet var arrayController: NSArrayController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetcher.fetchCoursesUsingCompletionHandler { (result) in
            switch result {
                case .Success(let courses):
                    print("Got courses: \(courses)")
                    self.courses = courses
                case .Failure(let error):
                    print("Got error: \(error)")
                    NSAlert(error: error).runModal()
                    self.courses = []
            }
        }
    }
    
    
    @IBAction func selectCourse(sender: AnyObject) {
        let selectedCourse = arrayController.selectedObjects.first as! Course?
        delegate?.courseListViewController(self, selectedCourse: selectedCourse)
    }

}
