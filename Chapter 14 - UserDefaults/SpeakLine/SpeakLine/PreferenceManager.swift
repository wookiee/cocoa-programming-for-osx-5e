//
//  PreferenceManager.swift
//  SpeakLine
//
//  Created by Juan Pablo Claude on 2/23/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

import Cocoa


private let activeVoiceKey = "activeVoice"
private let activeTextKey = "activeText"


class PreferenceManager {
    
    private let userDefaults = NSUserDefaults.standardUserDefaults()
    
    
    func registerDefaultPreferences() {
        let defaults = [ activeVoiceKey : NSSpeechSynthesizer.defaultVoice() , activeTextKey  : "Able was I ere I saw Elba." ]
        userDefaults.registerDefaults(defaults)
    }
    
    
    init() {
        registerDefaultPreferences()
    }
    
    
    var activeVoice: String? {
        set (newActiveVoice) {
            userDefaults.setObject(newActiveVoice, forKey: activeVoiceKey)
        }
        get {
            return userDefaults.objectForKey(activeVoiceKey) as? String
        }
    }
    
    
    var activeText: String? {
        set (newActiveText) {
            userDefaults.setObject(newActiveText, forKey: activeTextKey)
        }
        get {
            return userDefaults.objectForKey(activeTextKey) as? String
        }
    }
    
}
