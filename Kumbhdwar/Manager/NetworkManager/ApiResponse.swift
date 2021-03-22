//
//  ELAPIResponseProtocol.swift
//  EFSSLight
//
//  Created by SDS on 26/04/19.
//  Copyright © 2019 Samsung. All rights reserved.
//

import Foundation

enum ApiResponseCode: Int {
    case success = 200

    case noNetworkError = -10001
    case jsonParingError = -10002
    case serverError = -10003
    case accessTokenExpire = -10004
    case formDataEncodingError = -10005

    case unknownResponse = 0
}

struct APIResponse {


    var apiMessage: String = ""
    var statusCode: Int = 0

    var isSuccess: Bool {
        responseCode == .success
    }
    
    var responseCode: ApiResponseCode {
        ApiResponseCode(rawValue: statusCode) ?? .unknownResponse
    }

    var message: String? {
        getResponseMessage()
    }

    private func getResponseMessage() -> String {
        switch responseCode {
        case .success :
            return ""
        default:
            return ""
        }
    }
}

struct RCBasicResponseModel: Codable {
    var message: String?
    var success: Int?
    var statusCode: Int?

    enum CodingKeys: String, CodingKey {
        case message
        case success
        case statusCode
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        statusCode = try values.decodeIfPresent(Int.self, forKey: .statusCode)
        success = try values.decodeIfPresent(Int.self, forKey: .success)
    }
}
