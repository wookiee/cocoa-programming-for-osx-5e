//
//  CarArrayController.swift
//  CarLot
//
//  Created by Adam Preble on 4/10/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

import Cocoa

class CarArrayController: NSArrayController {
    
    override func newObject() -> Any {
        let newObj = super.newObject() as! NSObject
        let now = Date()
        newObj.setValue(now, forKey: "datePurchased")
        return newObj
    }
    
}
