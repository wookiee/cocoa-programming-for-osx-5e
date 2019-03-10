//
//  ScheduleFetcher.swift
//  RanchForecast
//
//  Created by Juan Pablo Claude on 2/16/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

import Foundation

open class ScheduleFetcher {
    
    public enum FetchCoursesResult {
        case success([Course])
        case failure(NSError)
        
        init(throwingClosure: () throws -> [Course]) {
            do {
                let courses = try throwingClosure()
                self = .success(courses)
            }
            catch {
                self = .failure(error as NSError)
            }
        }
    }
    
    let session: URLSession
    
    
    public init() {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
    }
    
    
    func fetchCoursesUsingCompletionHandler(_ completionHandler: @escaping (FetchCoursesResult) -> Void) {
        let url = URL(string: "http://bookapi.bignerdranch.com/courses.json")!
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            let result: FetchCoursesResult
            = self.resultFromData(data, response: response, error: error as NSError?)
            
            OperationQueue.main.addOperation {
                completionHandler(result)
            }
        }) 
        task.resume()
    }
    
    
    func errorWithCode(_ code: Int, localizedDescription: String) -> NSError {
        return NSError(domain: "ScheduleFetcher",
            code: code,
            userInfo: [NSLocalizedDescriptionKey: localizedDescription])
    }
    
    
    open func courseFromDictionary(_ courseDict: NSDictionary) -> Course? {
        let title = courseDict["title"] as! String
        let urlString = courseDict["url"] as! String
        let upcomingArray = courseDict["upcoming"] as! [NSDictionary]
        let nextUpcomingDict = upcomingArray.first!
        let nextStartDateString = nextUpcomingDict["start_date"] as! String
        
        let url = URL(string: urlString)!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let nextStartDate = dateFormatter.date(from: nextStartDateString)!
        
        return Course(title: title, url: url, nextStartDate: nextStartDate)
    }
    
    
    func coursesFromData(_ data: Data) throws -> [Course] {
        let topLevelDict = try JSONSerialization.jsonObject(with: data,
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
    
    
    open func resultFromData(_ data: Data?, response: URLResponse?, error: NSError?)
        -> FetchCoursesResult {
            let result: FetchCoursesResult
            
            if let data = data {
                if let response = response as? HTTPURLResponse {
                    print("\(data.count) bytes, HTTP \(response.statusCode).")
                    if response.statusCode == 200 {
                        result = FetchCoursesResult { try self.coursesFromData(data) }
                    }
                    else {
                        let error =
                        self.errorWithCode(2, localizedDescription:
                            "Bad status code \(response.statusCode)")
                        result = .failure(error)
                    }
                }
                else {
                    let error =
                    self.errorWithCode(1, localizedDescription:
                        "Unexpected response object.")
                    result = .failure(error)
                }
            }
            else {
                result = .failure(error!)
            }
            
            return result
    }
    
}
