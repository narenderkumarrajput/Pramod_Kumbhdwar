//
//  User.swift
//
//  Created by Pawan Joshi on 21/02/17
//  Copyright (c) Appster. All rights reserved.
//

import Foundation
import SwiftyJSON

public enum UserType: Int {
    case salesRep = 2
    case technitian = 3
}

public enum BadgeIDType: String {
    case primaryType = "primary"
    case secondaryType = "secondary"
    case defaultType = "default"
}

public enum BadgeIDFont: String {
    case avenier = "Avenier LT Pro"
    case standard = "standard"
}

public final class User: NSObject, NSCoding {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let UHouseId = "UHouseId"
        static let RoleId = "RoleId"
        static let CNO = "CNO"
        static let EmpCode = "EmpCode"
    }
    
    public var UHouseId: String?
    public var RoleId: String?
    public var CNO: String?
    public var EmpCode: String?
    
    public override init() {
        super.init()
    }
    
    // MARK: SwiftyJSON Initializers
    /// Initiates the instance based on the object.
    ///
    /// - parameter object: The object of either Dictionary or Array kind that was passed.
    /// - returns: An initialized instance of the class.
    public convenience init(object: Any) {
        self.init(json: JSON(object))
    }
    
    /// Initiates the instance based on the JSON that was passed.
    ///
    /// - parameter json: JSON object from SwiftyJSON.
    public required init(json: JSON) {
        UHouseId = json[SerializationKeys.UHouseId].string
        RoleId = json[SerializationKeys.RoleId].string
        CNO = json[SerializationKeys.CNO].string
        EmpCode = json[SerializationKeys.EmpCode].string
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [String: Any]()
        if let value = UHouseId {
            dictionary[SerializationKeys.UHouseId] = value
        }
        if let value = RoleId {
            dictionary[SerializationKeys.RoleId] = value
        }
        if let value = CNO {
            dictionary[SerializationKeys.CNO] = value
        }
        if let value = EmpCode {
            dictionary[SerializationKeys.EmpCode] = value
        }
        return dictionary
    }
    
    // MARK: NSCoding Protocol
    public required init(coder aDecoder: NSCoder) {
        UHouseId = aDecoder.decodeObject(forKey: SerializationKeys.UHouseId) as? String
        RoleId = aDecoder.decodeObject(forKey: SerializationKeys.RoleId) as? String
        CNO = aDecoder.decodeObject(forKey: SerializationKeys.CNO) as? String
        EmpCode = aDecoder.decodeObject(forKey: SerializationKeys.EmpCode) as? String
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(UHouseId, forKey: SerializationKeys.UHouseId)
        aCoder.encode(RoleId, forKey: SerializationKeys.RoleId)
        aCoder.encode(CNO, forKey: SerializationKeys.CNO)
        aCoder.encode(EmpCode, forKey: SerializationKeys.EmpCode)
        
    }
}
