//
//  Course.swift
//  RanchForecast
//
//  Created by Juan Pablo Claude on 2/16/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

import Foundation

open class Course: NSObject {
    @objc open let title: String
    @objc open let url: URL
    @objc open let nextStartDate: Date
    
    public init(title: String, url: URL, nextStartDate: Date) {
        self.title = title
        self.url = url
        self.nextStartDate = nextStartDate
        super.init()
    }
}
