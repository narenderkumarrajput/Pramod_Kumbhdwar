//
//  String+Additions.swift
//
//  Created by Pawan Joshi on 30/03/16.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import UIKit

// MARK: - String Extension
extension String {

    func toDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    /**
     Convert html string into  normal string
     */
    //    var html2AttributedString: NSAttributedString? {
    //        guard
    //            let data = data(using: String.Encoding.utf8)
    //        else { return nil }
    //        do {
    //            return try NSAttributedString(data: data, options: [NSAttributedString.DocumentAttributeKey.documentType: NSAttributedString.DocumentType.html, NSAttributedString.DocumentAttributeKey.characterEncoding: String.Encoding.utf8], documentAttributes: nil)
    //        } catch let error as NSError {
    //            print(error.localizedDescription)
    //            return nil
    //        }
    //    }
    //
    //    var html2String: String {
    //        return html2AttributedString?.string ?? ""
    //    }
}
