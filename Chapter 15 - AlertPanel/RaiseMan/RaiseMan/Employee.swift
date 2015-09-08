//
//  Employee.swift
//  RaiseMan
//
//  Created by Nicholas Teissler on 2/20/15.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

import Foundation

class Employee: NSObject, NSCoding {
    var name: String? = "New Employee"
    var raise: Float = 0.05
    
    // MARK: - NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        if let name = name {
            aCoder.encodeObject(name, forKey: "name")
        }
        aCoder.encodeFloat(raise, forKey: "raise")
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey("name") as! String?
        raise = aDecoder.decodeFloatForKey("raise")
        super.init()
    }
    
    override init() {
        super.init()
    }
    
    func validateRaise(raiseNumberPointer: AutoreleasingUnsafeMutablePointer<NSNumber?>) throws {
            let raiseNumber = raiseNumberPointer.memory
            if raiseNumber == nil {
                let domain = "UserInputValidationErrorDomain"
                let code = 0
                let userInfo =
                    [NSLocalizedDescriptionKey : "An employee's raise must be a number."]
                throw NSError(domain: domain,
                                            code: code,
                                        userInfo: userInfo)
            } else {
                return
            }
    }
}
