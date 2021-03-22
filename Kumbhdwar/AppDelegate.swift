//
//  AppDelegate.swift
//  Kumbhdwar
//
//  Created by Narender Kumar on 12/03/21.
//  Copyright © 2021 Narender Kumar. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import IQKeyboardManagerSwift
import DropDown

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window:UIWindow?
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GMSServices.provideAPIKey(Constants.Google.ApiKey)
        GMSPlacesClient.provideAPIKey(Constants.Google.ApiKey)
        IQKeyboardManager.shared.enable = true
        DropDown.startListeningToKeyboard()
        
        self.presentRootViewController(true)
        return true
    }

    
    
    // MARK: - Root View Controller
    func presentRootViewController(_ animated: Bool = false) {
        if animated {
            let animation: CATransition = CATransition()
            animation.duration = CFTimeInterval(0.5)
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            animation.type = CATransitionType.moveIn
            animation.subtype = CATransitionSubtype.fromTop
            animation.fillMode = CAMediaTimingFillMode.forwards
            window?.layer.add(animation, forKey: "animation")
        }
        window?.rootViewController = rootViewController()
        // window?.rootViewController = testRootController()
    }
    
    fileprivate func rootViewController() -> UIViewController! {
        if UserManager.shared.isUserLoggedIn() {
            //TODO
            let sb = UIStoryboard(name: Constants.StroyboardFiles.dashboard, bundle: nil)
            let mainVC = sb.instantiateViewController(withIdentifier: "DashboardNav")
            return mainVC
        } else {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let mainVC = sb.instantiateViewController(withIdentifier: "MainNav")
            return mainVC
        }
    }

}


extension AppDelegate {
    
    struct PushCategoryIdentifiers {
        static let NONE = "NONE"
        static let CUSTOMNOTIFICATION = "CUSTOMNOTIFICATION"
    }
    
}
