//
//  KeyManager.swift
//  FlickerApi
//
//  Created by ayako_sayama on 2017-07-05.
//  Copyright © 2017 ayako_sayama. All rights reserved.
//

import Foundation

struct KeyManager {
    
    static private let keyFilePath = Bundle.main.path(forResource: "apiKey", ofType: "plist")
    
    static func getKeys() -> NSDictionary? {
        guard let keyFilePath = keyFilePath else {
            return nil
        }
        return NSDictionary(contentsOfFile: keyFilePath)
    }
    
    static func getValue(key: String) -> AnyObject? {
        guard let keys = getKeys() else {
            return nil
        }
        return keys[key]! as AnyObject
    }
}
