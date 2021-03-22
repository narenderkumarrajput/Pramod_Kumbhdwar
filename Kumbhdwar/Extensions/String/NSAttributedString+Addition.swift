//
//  NSAttributedString+Addition.swift
//  EFSSLight
//
//  Created by SDS on 24/07/19.
//  Copyright © 2019 Samsung. All rights reserved.
//

import Foundation
import UIKit
extension NSAttributedString {
    convenience init(htmlString html: String, font: UIFont = UIFont.systemFont(ofSize: 20)) throws {
        // let font: UIFont = UIFont.systemFont(ofSize: 20)
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue]

        let data = html.data(using: .utf8, allowLossyConversion: true)
        let fontFamily = font.familyName
        guard data != nil, let attr = try? NSMutableAttributedString(data: data!, options: options, documentAttributes: nil) else {
            try self.init(data: data ?? Data(html.utf8), options: options, documentAttributes: nil)
            return
        }

        let fontSize: CGFloat? = font.pointSize
        let range = NSRange(location: 0, length: attr.length)
        attr.enumerateAttribute(.font, in: range, options: .longestEffectiveRangeNotRequired) { attrib, range, _ in
            if let htmlFont = attrib as? UIFont {
                let traits = htmlFont.fontDescriptor.symbolicTraits
                var descrip = htmlFont.fontDescriptor.withFamily(fontFamily)

                if (traits.rawValue & UIFontDescriptor.SymbolicTraits.traitBold.rawValue) != 0 {
                    descrip = descrip.withSymbolicTraits(.traitBold)!
                }

                if (traits.rawValue & UIFontDescriptor.SymbolicTraits.traitItalic.rawValue) != 0 {
                    descrip = descrip.withSymbolicTraits(.traitItalic)!
                }

                attr.addAttribute(.font, value: UIFont(descriptor: descrip, size: fontSize ?? htmlFont.pointSize), range: range)
                attr.addAttribute(.foregroundColor, value: UIColor.red, range: range)
            }
        }

        self.init(attributedString: attr)
    }
}
