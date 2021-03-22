//
//  String+Additions.swift
//
//  Created by Pawan Joshi on 30/03/16.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

// MARK: - String Extension
extension String {

    /**
     Specify that string contains valid email address.

     - returns: A Bool return true if string has valid email otherwise false.
     */
    func isValidEmail() -> Bool {

        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }

    /**
     Specify that string contains valid password.

     - returns: A Bool return true if string has valid password otherwise false.
     */
    func isValidPassword() -> Bool {

        let passwordRegex = "^[a-zA-Z_0-9\\-#!$@~`%&*()_+=|\"\':;?/>.<,]{6,18}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        let rVal = passwordTest.evaluate(with: self)
        if !rVal {
        }
        return rVal
    }
    
    public var validPhoneNumber:Bool {
        let charcterSet  = NSCharacterSet(charactersIn: "+0123456789").inverted
        let inputString = self.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        return  self == filtered
    }

    /**
     Specify that string contains valid web url.

     - returns: A Bool return true if it is valid url otherwise false.
     */
    func isValidUrl() -> Bool {

        let urlFormat = "(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
        let urlPredicate = NSPredicate(format: "SELF MATCHES %@", urlFormat)
        return urlPredicate.evaluate(with: self)
    }

    /**
     Specify that string is empty or not.

     - returns: A Bool return true if string has value otherwise false.
     */
    func isNullOrEmpty() -> Bool {

        let optionalString: String? = self
        if optionalString == "(null)" || optionalString?.isEmpty == true {
            return true
        }
        return false
    }

    /**
     Match password is validate or not.

     - parameter password: String of password

     - returns: A Bool return true if password is validate otherwise false
     */
    fileprivate func validatePassword(_ password: String) -> Bool {

        // This regular expression allowes 2 to 8 character passwords.
        // It requires to have at least 1 alphanumeric (letter/number) character and 1 non-alphanumeric character
        let passwordRegex = "^(?=.*[0-9]+.*)(?=.*[a-zA-Z]+.*)[0-9a-zA-Z.!&/()=?+*~#'_:.,;-]{6,32}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }

    /**
     Match password with confirm password.

     - parameter password:        String of password
     - parameter confirmPassword: Strinf of confirm password

     - returns: A Bool return true if password is match with confirm password otherwise false
     */
    fileprivate func passwordComparision(_ password: String, confirmPassword: String) -> Bool {

        // This regular expression allowes 2 to 8 character passwords.
        // It requires to have at least 1 alphanumeric (letter/number) character and 1 non-alphanumeric character

        if password == confirmPassword {
            return true
        }
        return false
    }
}


extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}
