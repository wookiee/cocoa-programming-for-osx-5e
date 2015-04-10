//
//  Course.swift
//  RanchForecast
//
//  Created by Juan Pablo Claude on 2/16/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

import Foundation

public class Course: NSObject {
    public let title: String
    public let url: NSURL
    public let nextStartDate: NSDate
    
    public init(title: String, url: NSURL, nextStartDate: NSDate) {
        self.title = title
        self.url = url
        self.nextStartDate = nextStartDate
        super.init()
    }
}