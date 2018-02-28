//
//  GeneratePassword.swift
//  RandomPassword
//
//  Created by Nate Chandler on 4/20/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

import Foundation

private let characters = "0123456789abcdefghijklmnopqrstuvwxyz" +
                               "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

func generateRandomString(_ length: Int) -> String {
    // Start with an empty string
    var string = ""
    
    // Append 'length' number of random characters
    for _ in 0..<length {
        string.append(generateRandomCharacter())
    }
    return string
}

func generateRandomCharacter() -> Character {
    // Create a random index into the characters array
    let index = Int(arc4random_uniform(UInt32(characters.count)))
    
    // Create a String.index from the random index
    let characterIndex = characters.index(characters.startIndex, offsetBy: index)
    
    // Get and return a random character
    let character = characters[characterIndex]
    return character
}
