//
//  NotificationBannerManager.swift
//  MemTree
//
//  Created by Pawan Joshi on 22/01/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import UIKit

class NotificationBannerManager: NSObject {

    // MARK: - Singleton Instance
    fileprivate static let _sharedNotificationBannerManager = NotificationBannerManager()
    
    static var shared: NotificationBannerManager {
        return _sharedNotificationBannerManager
    }
    
    fileprivate var chatNotificationQueueCount: Int = 0
    fileprivate var isNotificationVisible: Bool = false
    
    fileprivate override init() {
        super.init()
        notificationSetup()
    }
    
    func notificationSetup() {
        NotificationCenter.default.addObserver(self, selector: #selector(NotificationBannerManager.bannerDidAppear(_:)), name: NotificationBanner.BannerDidAppear, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NotificationBannerManager.bannerDidDisappear(_:)), name: NotificationBanner.BannerDidDisappear, object: nil)
    }
    
    @objc func bannerDidAppear(_ banner: NotificationBanner) {
        
    }
    
    @objc func bannerDidDisappear(_ banner: NotificationBanner) {
        
    }
    
    func showSuccessNotification(title: String, subtitle: String, onTapHandler: @escaping () -> Void) {
        let banner = NotificationBanner(title: title, subtitle: subtitle, style: .success, colors: NotificationBannerManager.shared)
        banner.onTap = onTapHandler
        banner.show()
    }
    
    func showFailierNotification(title: String, subtitle: String, onTapHandler: @escaping () -> Void) {
        let banner = NotificationBanner(title: title, subtitle: subtitle, style: .danger, colors: NotificationBannerManager.shared)
        banner.onTap = onTapHandler
        banner.show()
    }
    func showAppPushNotification(title: String, subtitle: String, onTapHandler: @escaping () -> Void) {
        let banner = NotificationBanner(title: title, subtitle: subtitle, style: .info, colors: NotificationBannerManager.shared)
        banner.onTap = onTapHandler
        banner.show()
    }
    
}

extension NotificationBannerManager: BannerColorsProtocol {
    func color(for style: BannerStyle) -> UIColor {
        var color = UIColor.darkGray
        switch style {
        case BannerStyle.danger:
            color = UIColor.red
            return color
        case BannerStyle.success:
            color = UIColor.green
            return color
        case BannerStyle.info:
            color = UIColor.blue
            return color
        default:
            return color
        }
    }
}

extension NotificationBannerManager: NotificationBannerDelegate {
    func notificationBannerWillAppear(_ banner: BaseNotificationBanner) {
        
    }
    
    func notificationBannerDidAppear(_ banner: BaseNotificationBanner) {
        
    }
    
    func notificationBannerWillDisappear(_ banner: BaseNotificationBanner) {
        
    }
    
    func notificationBannerDidDisappear(_ banner: BaseNotificationBanner) {
        
    }
    
    
}
