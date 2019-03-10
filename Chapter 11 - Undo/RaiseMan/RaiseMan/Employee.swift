//
//  Employee.swift
//  RaiseMan
//
//  Created by Nate Chandler on 9/1/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

import Foundation

class Employee: NSObject {
    @objc var name: String? = "New Employee"
    @objc var raise: Float = 0.05
    
    func validateRaise(_ raiseNumberPointer: AutoreleasingUnsafeMutablePointer<NSNumber?>) throws {
            let raiseNumber = raiseNumberPointer.pointee
            if raiseNumber == nil {
                let domain = "UserInputValidationErrorDomain"
                let code = 0
                let userInfo =
                    [NSLocalizedDescriptionKey : "An employee's raise must be a number."]
                throw NSError(domain: domain, code: code, userInfo: userInfo)
            }
    }
}
