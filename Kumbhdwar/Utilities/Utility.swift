//
//  Utility.swift
//  Advantage
//
//  Created by Narender Kumar on 12/03/21.
//  Copyright © 2020 Shreehari Bhat. All rights reserved.
//

import Foundation
import UIKit
import Reachability

struct Utility {

    static func showLoaderWithTextMsg(text: String) {
        SKActivityIndicator.show(text, userInteractionStatus: false)
    }
    
    static func showLoader() {
        SKActivityIndicator.show("", userInteractionStatus: false)
    }
    
    static func hideLoader() {
        SKActivityIndicator.dismiss()
    }
    
    static func showToastNotification(_ message: String) {
        
    }
    
    //MARK:- JSON
    static func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    //MARK:- APPINFO
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    static let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String

    static func deviceID() -> String {
        let deviceID = UIDevice.current.identifierForVendor?.uuidString
        return deviceID!
    }

    // Global variables
    static var defaultAPIServiceHeaders: [String: String] {
        var headers: [String: String] = [String: String]()
        headers["Accept"] = "application/json"
        headers["Content-Type"] = "application/json"
        return headers
    }
        
    // Show Alert With String
    static func showAlertWithString(_ message : String) -> UIAlertController {
        let alert = UIAlertController(title: Constants.appName, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) {(alert: UIAlertAction!) in
            // Ok Action Handler
        }
        alert.addAction(okAction)
        return alert
    }
    
    static func showAlertwithString(_ message: String?, withTitle title: String?, otherButton okButton: String?) -> UIAlertController? {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let yesButton = UIAlertAction(title: okButton, style: .default, handler: { action in
                //Handle your yes please button action here
            })
        alert.addAction(yesButton)
        return alert
    }
    
    static func isNetworkReachable() -> Bool {
        var isReachable = false
        let reachability = try! Reachability()
        if reachability.connection != .unavailable {
            isReachable = true
        }
        else if reachability.connection == .unavailable {
            isReachable = false
        }
        return isReachable
    }

    static func validateEmailWithString(_ email : String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

}
