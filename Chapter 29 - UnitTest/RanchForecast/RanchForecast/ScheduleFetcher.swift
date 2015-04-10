//
//  ScheduleFetcher.swift
//  RanchForecast
//
//  Created by Juan Pablo Claude on 2/16/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

import Foundation

public class ScheduleFetcher {
    
    public enum FetchCoursesResult {
        case Success([Course])
        case Failure(NSError)
    }
    
    let session: NSURLSession
    
    
    public init() {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        session = NSURLSession(configuration: config)
    }
    
    
    func fetchCoursesUsingCompletionHandler(completionHandler: (FetchCoursesResult) -> (Void)) {
        let url = NSURL(string: "http://bookapi.bignerdranch.com/courses.json")!
        let request = NSURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(request, completionHandler: {
            (data, response, error) -> Void in
            var result: FetchCoursesResult = self.resultFromData(data, response: response, error: error)
            NSOperationQueue.mainQueue().addOperationWithBlock({
            completionHandler(result)
            })
        })
        task.resume()
    }
    
    
    func errorWithCode(code: Int, localizedDescription: String) -> NSError {
            return NSError(domain: "ScheduleFetcher",
                             code: code,
                         userInfo: [NSLocalizedDescriptionKey: localizedDescription])
    }
    
    
    public func courseFromDictionary(courseDict: NSDictionary) -> Course? {
        let title = courseDict["title"] as! String
        let urlString = courseDict["url"] as! String
        let upcomingArray = courseDict["upcoming"] as! [NSDictionary]
        let nextUpcomingDict = upcomingArray.first!
        let nextStartDateString = nextUpcomingDict["start_date"] as! String
        
        let url = NSURL(string: urlString)!
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let nextStartDate = dateFormatter.dateFromString(nextStartDateString)!
        
        return Course(title: title, url: url, nextStartDate: nextStartDate)
    }
    
    
    func resultFromData(data: NSData) -> FetchCoursesResult {
        var error: NSError?
        let topLevelDict = NSJSONSerialization.JSONObjectWithData(data,
                options: NSJSONReadingOptions.allZeros,
                error: &error) as! NSDictionary?
        
        if let topLevelDict = topLevelDict {
            let courseDicts = topLevelDict["courses"] as! [NSDictionary]
            var courses: [Course] = []
            for courseDict in courseDicts {
                if let course = courseFromDictionary(courseDict) {
                    courses.append(course)
                }
            }
            return .Success(courses)
        }
        else {
            return .Failure(error!)
        }
    }
    
    
    public func resultFromData(data: NSData!, response: NSURLResponse!, error: NSError!) -> FetchCoursesResult {
        var result: FetchCoursesResult
        if data == nil {
            result = .Failure(error)
        }
            else if let response = response as? NSHTTPURLResponse {
            println("\(data.length) bytes, HTTP \(response.statusCode).")
            if response.statusCode == 200 {
                result = self.resultFromData(data)
            }
                else {
                let error = self.errorWithCode(1, localizedDescription: "Bad status code \(response.statusCode)")
                result = .Failure(error)
            }
        }
            else {
            let error = self.errorWithCode(1, localizedDescription: "Unexpected response object.")
            result = .Failure(error)
        }
        return result
    }
    
}
