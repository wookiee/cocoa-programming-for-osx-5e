//
//  Constants.swift
//  RanchForecast
//
//  Created by Juan Pablo Claude on 2/16/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

import Foundation

class Constants {
    static let urlString = "http://training.bignerdranch.com/classes/test-course"
    static let url = URL(string: urlString)!
    static let title = "Test Course"
    
    static let dateString = "2014-06-02"
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    static let date = dateFormatter.date(from: dateString)!
    
    static let validCourseDict = ["title" : title,
                                  "url": urlString,
                                  "upcoming" : [["start_date": dateString]]] as [String : Any]
    
    static let coursesDictionary = ["courses" : [validCourseDict]]
    
    static let okResponse = HTTPURLResponse(url: url,
                                       statusCode: 200,
                                      httpVersion: nil,
                                     headerFields: nil)
    
    static let jsonData = try! JSONSerialization.data(withJSONObject: coursesDictionary,
                                                             options: [])
}
