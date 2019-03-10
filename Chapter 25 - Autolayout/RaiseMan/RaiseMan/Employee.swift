//
//  Employee.swift
//  RaiseMan
//
//  Created by Nicholas Teissler on 2/20/15.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

import Foundation

class Employee: NSObject, NSCoding {
    @objc var name: String? = "New Employee"
    @objc var raise: Float = 0.05
    
    // MARK: - NSCoding
    func encode(with aCoder: NSCoder) {
        if let name = name {
            aCoder.encode(name, forKey: "name")
        }
        aCoder.encode(raise, forKey: "raise")
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String?
        raise = aDecoder.decodeFloat(forKey: "raise")
        super.init()
    }
    
    override init() {
        super.init()
    }
    
    func validateRaise(_ raiseNumberPointer: AutoreleasingUnsafeMutablePointer<NSNumber?>,
                           error outError: NSErrorPointer) -> Bool {
            let raiseNumber = raiseNumberPointer.pointee
            if raiseNumber == nil {
                let domain = "UserInputValidationErrorDomain"
                let code = 0
                let userInfo =
                    [NSLocalizedDescriptionKey : "An employee's raise must be a number."]
                outError?.pointee = NSError(domain: domain,
                                            code: code,
                                        userInfo: userInfo)
                return false
            } else {
                return true
            }
    }
}
