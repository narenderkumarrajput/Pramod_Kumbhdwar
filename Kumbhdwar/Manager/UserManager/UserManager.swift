//
//  UserManager.swift
//  Virdrobe
//
//  Created by Pawan Joshi on 13/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import Alamofire

let TEMP_USER_KEY = "tempUser"
let ACTIVE_USER_KEY = "activeUser"
let LOGGED_USER_EMAIL_KEY = "userEmail"

class UserManager: NSObject {

    fileprivate var activeUserIvar: User?

    var activeUser: User! {
        get {
            return activeUserIvar
        }
        set {
            activeUserIvar = newValue

            if let _ = activeUserIvar {
                saveActiveUser()
            }
        }
    }

    fileprivate var tempUserIvar: User?
    var tempUser: User! {
        get {
            return tempUserIvar
        }
        set {
            tempUserIvar = newValue
            
            if let _ = tempUserIvar {
                saveTempUser()
            }
        }
    }
    
    fileprivate var userTokenIvar: String = ""

    var userToken: String {

        set(newValue) {
            userTokenIvar = newValue
            let defaults = UserDefaults.standard
            defaults.set(userTokenIvar, forKey: "userToken")
            defaults.synchronize()
        }
        get {
            let defaults = UserDefaults.standard
            guard let _uToken = defaults.value(forKey: "userToken") else {
                userTokenIvar = ""
                return userTokenIvar
            }
            userTokenIvar = _uToken as! String
            return userTokenIvar
        }
    }
    

    // MARK: Singleton Instance
    private static let _sharedManager = UserManager()

    open class var shared: UserManager {
        return _sharedManager
    }

    fileprivate override init() {
        // initiate any queues / arrays / filepaths etc
        super.init()
        // Load last logged user data if exists
        if isUserLoggedIn() {
            loadActiveUser()
        } else if isTempUserAvailable() {
            //loadTempUser()
        }
    }

    func isUserLoggedIn() -> Bool {
        guard let user = UserDefaults.objectForKey(ACTIVE_USER_KEY)
        else {
            return false
        }
        loadActiveUser()
        return true
    }

    func isTempUserAvailable() -> Bool {
        
        guard let _ = UserDefaults.objectForKey(TEMP_USER_KEY)
            else {
                return false
        }
        loadTempUser()
        return true
    }
    
    func userLogout() {
        deleteActiveUser()
         //Added as on logging out token should be set to empty
        UserManager.shared.userToken = ""
    }

    // MARK: - KeyChain / User Defaults / Flat file / XML

    /**
     Load last logged user data, if any
     */
    func loadActiveUser() {
        
        guard let decodedUser = UserDefaults.objectForKey(ACTIVE_USER_KEY) as? Data,
            let user = NSKeyedUnarchiver.unarchiveObject(with: decodedUser) as? User
            else {
                return
        }
        self.activeUser = user
    }

    func loadTempUser() {

        guard let decodedUser = UserDefaults.objectForKey(TEMP_USER_KEY) as? Data,
            let user = try? NSKeyedUnarchiver.unarchivedObject(ofClass: User.self, from: decodedUser)
            else {
                return
        }
        self.tempUser = user
    }
    func lastLoggedUserEmail() -> String? {

        return UserDefaults.objectForKey(LOGGED_USER_EMAIL_KEY) as? String
    }

    /**
     * Save current user data
     */
    func saveActiveUser() {
        if let _ = self.activeUser {
            //let archived = try? NSKeyedArchiver.archivedData(withRootObject: self.activeUser!, requiringSecureCoding: false)
            //UserDefaults.setObject(archived as AnyObject?, forKey: ACTIVE_USER_KEY)
            UserDefaults.setObject(NSKeyedArchiver.archivedData(withRootObject: self.activeUser!) as AnyObject?, forKey: ACTIVE_USER_KEY)
            
            UserDefaults.setObject("Email@abc.com" as AnyObject?, forKey: LOGGED_USER_EMAIL_KEY)
        }
        
    }

    func saveTempUser() {

        let archived = try? NSKeyedArchiver.archivedData(withRootObject: self.tempUser!, requiringSecureCoding: false)
        
        UserDefaults.setObject(archived as AnyObject?, forKey: TEMP_USER_KEY)

    }
    /**
     * Delete current user data
     */
    func deleteActiveUser() {
        // remove active user from storage
        UserDefaults.removeObjectForKey(ACTIVE_USER_KEY)
        // free user object memory
        self.activeUser = nil
    }

    func deleteTempUser() {
        // remove active user from storage
        UserDefaults.removeObjectForKey(TEMP_USER_KEY)
        // free user object memory
        self.tempUser = nil
    }
}
