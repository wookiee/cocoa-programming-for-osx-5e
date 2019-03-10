//
//  MainSplitViewController.swift
//  RanchForecastSplit
//
//  Created by Juan Pablo Claude on 2/20/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

import Cocoa


class MainSplitViewController: NSSplitViewController, CourseListViewControllerDelegate {
    
    var masterViewController: CourseListViewController {
        return splitViewItems[0].viewController as! CourseListViewController
    }
    
    
    var detailViewController: WebViewController {
        return splitViewItems[1].viewController as! WebViewController
    }
    
    
    let defaultURL = URL(string: "http://www.bignerdranch.com/")!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        masterViewController.delegate = self
        detailViewController.loadURL(defaultURL)
    }
    
    
    // MARK: CourseListViewControllerDelegate
    func courseListViewController(_ viewController: CourseListViewController,
                                  selectedCourse: Course?) {
        if let course = selectedCourse {
            detailViewController.loadURL(course.url)
        }
        else {
            detailViewController.loadURL(defaultURL)
        }
    }
    
}
