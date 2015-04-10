//
//  CourseTests.swift
//  RanchForecast
//
//  Created by Juan Pablo Claude on 2/16/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

import XCTest
import RanchForecast

class CourseTests: XCTestCase {
    
    func testCourseInitialization() {
        let course = Course(title: Constants.title,
                              url: Constants.url,
                    nextStartDate: Constants.date)
        
        XCTAssertEqual(course.title, Constants.title)
        XCTAssertEqual(course.url, Constants.url)
        XCTAssertEqual(course.nextStartDate, Constants.date)
    }
    
    
}
