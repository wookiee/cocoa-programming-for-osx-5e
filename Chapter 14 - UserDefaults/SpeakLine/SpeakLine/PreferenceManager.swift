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
    
    fileprivate let userDefaults = UserDefaults.standard
    
    
    func registerDefaultPreferences() {
        let defaults = [ activeVoiceKey : NSSpeechSynthesizer.defaultVoice , activeTextKey  : "Able was I ere I saw Elba." ] as [String : Any]
        userDefaults.register(defaults: defaults)
    }
    
    
    init() {
        registerDefaultPreferences()
    }
    
    
    var activeVoice: String? {
        set (newActiveVoice) {
            userDefaults.set(newActiveVoice, forKey: activeVoiceKey)
        }
        get {
            return userDefaults.object(forKey: activeVoiceKey) as? String
        }
    }
    
    
    var activeText: String? {
        set (newActiveText) {
            userDefaults.set(newActiveText, forKey: activeTextKey)
        }
        get {
            return userDefaults.object(forKey: activeTextKey) as? String
        }
    }
    
}
