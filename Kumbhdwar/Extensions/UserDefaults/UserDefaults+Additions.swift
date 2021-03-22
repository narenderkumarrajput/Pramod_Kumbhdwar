//
//  UserDefaults+Additions.swift
//
//  Created by Arvind Singh on 13/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

// MARK: - NSUserDefaults Extension
extension UserDefaults {

    // MARK: - User Defaults
    /**
     sets/adds object to NSUserDefaults

     - parameter aObject: object to be stored
     - parameter defaultName: key for object
     */
    class func setObject(_ value: AnyObject?, forKey defaultName: String) {
        UserDefaults.standard.set(value, forKey: defaultName)
        UserDefaults.standard.synchronize()
    }

    class func setBool(_ value: Bool?, forKey defaultName: String) {
        
        UserDefaults.standard.set(value, forKey: defaultName)
        UserDefaults.standard.synchronize()
    }
    
    class func setString(_ value: String?, forKey defaultName: String) {
        UserDefaults.standard.set(value, forKey: defaultName)
        UserDefaults.standard.synchronize()
    }
    /**
     gives stored object in NSUserDefaults for a key

     - parameter defaultName: key for object

     - returns: stored object for key
     */
    class func objectForKey(_ defaultName: String) -> AnyObject? {
        return UserDefaults.standard.object(forKey: defaultName) as AnyObject?
    }

    /**
     removes object from NSUserDefault stored for a given key

     - parameter defaultName: key for object
     */
    class func removeObjectForKey(_ defaultName: String) {
        UserDefaults.standard.removeObject(forKey: defaultName)
        UserDefaults.standard.synchronize()
    }
    
    class func setInt(_ value: Int?, forKey defaultName: String) {
        
        UserDefaults.standard.set(value, forKey: defaultName)
        UserDefaults.standard.synchronize()
    }
}
