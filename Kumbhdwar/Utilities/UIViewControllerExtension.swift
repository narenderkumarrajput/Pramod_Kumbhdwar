//
//  UIViewControllerExtension.swift
//  Advantage
//
//  Created by Narender Kumar on 12/03/21.
//  Copyright © 2020 Shreehari Bhat. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlertMessageWithAction(title: String?, message: String?, actionTitles:[String?], actions:[((UIAlertAction) -> Void)?]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, title) in actionTitles.enumerated() {
            if title == "Cancel" {
                let action = UIAlertAction(title: title, style: .destructive, handler: actions[index])
                alert.addAction(action)
            } else {
                let action = UIAlertAction(title: title, style: .default, handler: actions[index])
                alert.addAction(action)
            }
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithOk(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
        
}


//extension UIApplication {
//    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
//        if let navigationController = controller as? UINavigationController {
//            return topViewController(controller: navigationController.visibleViewController)
//        }
//        if let tabController = controller as? UITabBarController {
//            if let selected = tabController.selectedViewController {
//                return topViewController(controller: selected)
//            }
//        }
//        if let presented = controller?.presentedViewController {
//            return topViewController(controller: presented)
//        }
//        return controller
//    }
//}
