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
        
        init(throwingClosure: () throws -> [Course]) {
            do {
                let courses = try throwingClosure()
                self = .Success(courses)
            }
            catch {
                self = .Failure(error as NSError)
            }
        }
    }
    
    let session: NSURLSession
    
    
    public init() {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        session = NSURLSession(configuration: config)
    }
    
    
    func fetchCoursesUsingCompletionHandler(completionHandler: FetchCoursesResult -> Void) {
        let url = NSURL(string: "http://bookapi.bignerdranch.com/courses.json")!
        let request = NSURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            let result: FetchCoursesResult
            = self.resultFromData(data, response: response, error: error)
            
            NSOperationQueue.mainQueue().addOperationWithBlock {
                completionHandler(result)
            }
        }
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
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let nextStartDate = dateFormatter.dateFromString(nextStartDateString)!
        
        return Course(title: title, url: url, nextStartDate: nextStartDate)
    }
    
    
    func coursesFromData(data: NSData) throws -> [Course] {
        let topLevelDict = try NSJSONSerialization.JSONObjectWithData(data,
            options: [])
            as! NSDictionary
        
        let courseDicts = topLevelDict["courses"] as! [NSDictionary]
        var courses: [Course] = []
        for courseDict in courseDicts {
            if let course = courseFromDictionary(courseDict) {
                courses.append(course)
            }
        }
        return courses
    }
    
    
    public func resultFromData(data: NSData?, response: NSURLResponse?, error: NSError?)
        -> FetchCoursesResult {
            let result: FetchCoursesResult
            
            if let data = data {
                if let response = response as? NSHTTPURLResponse {
                    print("\(data.length) bytes, HTTP \(response.statusCode).")
                    if response.statusCode == 200 {
                        result = FetchCoursesResult { try self.coursesFromData(data) }
                    }
                    else {
                        let error =
                        self.errorWithCode(2, localizedDescription:
                            "Bad status code \(response.statusCode)")
                        result = .Failure(error)
                    }
                }
                else {
                    let error =
                    self.errorWithCode(1, localizedDescription:
                        "Unexpected response object.")
                    result = .Failure(error)
                }
            }
            else {
                result = .Failure(error!)
            }
            
            return result
    }
    
}
