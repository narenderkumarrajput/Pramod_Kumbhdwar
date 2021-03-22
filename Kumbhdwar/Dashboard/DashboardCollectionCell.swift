//
//  DashboardCollectionCell.swift
//  Kumbhdwar
//
//  Created by Peoplelink on 3/13/21.
//  Copyright © 2021 Narender Kumar. All rights reserved.
//

import UIKit

class DashboardCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.round()
    }
   
}

extension UIView {
    func round(enable: Bool = true, withRadius radius: CGFloat? = 8) {
        let cornerRadius = radius ?? bounds.height/2
        layer.cornerRadius = enable ? cornerRadius : 0
        layer.masksToBounds = enable
    }
    func circleWithBorderColor(enable: Bool = true, color: UIColor, width: CGFloat ) {
        self.layoutIfNeeded()
        let cornerRadius = min(bounds.width, bounds.height)/2
        layer.cornerRadius = enable ? cornerRadius : 0
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
        self.layer.masksToBounds = true
    }
    func borderWithColor(enable: Bool = true, withRadius radius: CGFloat? = 5, width: CGFloat? = 1.0, color: UIColor ) {
        
        self.layoutIfNeeded()
        let cornerRadius = radius ?? bounds.height/2
        layer.cornerRadius = enable ? cornerRadius : 0
        layer.cornerRadius = enable ? cornerRadius : 0
        self.layer.borderWidth = width ?? 1.0
        self.layer.borderColor = color.cgColor
        self.layer.masksToBounds = true
        
    }
}
extension String {

//    var length: Int {
//        return count
//    }
//
//    subscript (i: Int) -> String {
//        return self[i ..< i + 1]
//    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

//    subscript (r: Range<Int>) -> String {
//        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
//                                            upper: min(length, max(0, r.upperBound))))
//        let start = index(startIndex, offsetBy: range.lowerBound)
//        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
//        return String(self[start ..< end])
//    }
}
