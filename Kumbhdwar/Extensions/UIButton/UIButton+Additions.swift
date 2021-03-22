//
//  UIButton+Additions.swift
//
//  Created by Geetika Gupta on 01/04/16.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIButton Extension
extension UIButton {

    /**
     Override method of awake from nib to change font size as per aspect ratio.
     */
    open override func awakeFromNib() {

        super.awakeFromNib()

//        if let font = self.titleLabel?.font {
//
//            let screenRatio = UIScreen.main.bounds.size.width / CGFloat(320.0)
//            let fontSize = font.pointSize * screenRatio
//
//            titleLabel!.font = UIFont(name: font.fontName, size: fontSize)!
//        }
    }

    /**
     Make underline title
     */
    func underlineTitle() {

        if let buttonTitle = self.titleLabel?.text {
            let range = NSMakeRange(0, buttonTitle.count)
            underlineTitle(range)
        }
    }

    func underlineTitle(_ range: NSRange) {

        if let buttonTitle = self.titleLabel?.text {
            let titleString: NSMutableAttributedString = NSMutableAttributedString(string: buttonTitle)
            titleString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
            setAttributedTitle(titleString, for: UIControl.State())
        }
    }

    func underlineTextInTitle(_ text: String) {
        underlineTextsInTitle(text)
    }

    func underlineTextsInTitle(_ texts: String...) {

        if let buttonTitle = self.titleLabel?.text {
            let titleString: NSMutableAttributedString = NSMutableAttributedString(string: buttonTitle)

            for text in texts {
                let range = (buttonTitle as NSString).range(of: text)
                titleString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
            }

            setAttributedTitle(titleString, for: UIControl.State())
        }
    }
    
    func setShadow(width: CGFloat, height: CGFloat, color: UIColor, opacity: CGFloat = 1.0) {
        
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: width, height: height)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = Float(opacity)
        self.layer.masksToBounds = false
    }
}
