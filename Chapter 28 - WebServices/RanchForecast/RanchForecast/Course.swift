//
//  Course.swift
//  RanchForecast
//
//  Created by Juan Pablo Claude on 2/16/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

import Foundation

class Course: NSObject {
    @objc let title: String
    @objc let url: URL
    @objc let nextStartDate: Date
    
    init(title: String, url: URL, nextStartDate: Date) {
        self.title = title
        self.url = url
        self.nextStartDate = nextStartDate
        super.init()
    }
}
