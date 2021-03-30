//
//  NetworkManager.swift
//  Virdrobe
//
//  Created by Pawan Joshi on 14/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NetworkManager: NSObject {

    let manager = NetworkReachabilityManager(host: Constants.BaseUrl)

    // MARK: Singleton Instance

    private static let _sharedManager = NetworkManager()

    open class var shared: NetworkManager {
        return _sharedManager
    }

    fileprivate override init() {
        // initiate any queues / arrays / filepaths etc
        super.init()
    }


    class func isNetworkReachable() -> Bool {

        let manager = NetworkReachabilityManager(host: Constants.BaseUrl)
        print("Is Network Reachable ==========>>")
        let isReachable = manager?.isReachable ?? false
        if !isReachable {
            print("Network not reachable = \(isReachable)")
        }
        return isReachable
    }

    class func requestGETURL(_ urlString: String, headers: [String: String]?, params: [String: String] = [:], success: @escaping (JSON) -> Void, failure: @escaping (NSError) -> Void) {

        guard NetworkManager.isNetworkReachable() else {
            failure(Utilities.noInternetConnection())
            return
        }
        var header = headers ?? [String: String]()
        header["Version"] = Utilities.appVersion
        header["Build-Number"] = Utilities.buildNumber
        header["Device-Type"] = "ios"
        header["Authorization"] = "Basic cGF0bmE6cGF0bmEjMjAyMA=="
        Alamofire.request(urlString, method: .get, parameters: params, encoding: URLEncoding.default, headers: header).responseString(completionHandler: { (response) in
            print("response String===========>>")
            print(response)
        }).responseJSON { (responseObject) -> Void in
            print("requestGETURL ==========>>")
            print(responseObject.request?.url?.absoluteString)
            print("Request headers ==========>>")
            print(header)

            if responseObject.result.isSuccess {
                print(responseObject)
                let resJson = JSON(responseObject.result.value!)
                let responseDictionary = resJson.dictionaryObject
                if let message = responseDictionary?[Constants.ResponseKeys.message] as? String, message == "Your session has been expired. Please logout and log back in." {
                    //UserManager.shared.deleteActiveUser()
                    AppDelegate.shared.presentRootViewController()
                }
                success(resJson)
            }
            if responseObject.result.isFailure {
                print(responseObject)
                let error: Error = responseObject.result.error!
                failure(error as NSError)
            }
        }
    }

    class func requestPOSTURL(_ urlString: String, params: [String: AnyObject]?, headers: [String: String]?, success: @escaping (JSON) -> Void, failure: @escaping (NSError) -> Void) {

        var header = headers ?? [String: String]()
        header["Version"] = Utilities.appVersion
        header["Build-Number"] = Utilities.buildNumber
        header["Device-Type"] = "ios"
        header["Authorization"] = "Basic cGF0bmE6cGF0bmEjMjAyMA=="
        guard NetworkManager.isNetworkReachable() else {
            failure(Utilities.noInternetConnection())
            return
        }

        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header).responseString(completionHandler: { (response) in
            print("response String===========>>")
            print(response)
        }).responseJSON { (responseObject) -> Void in
            print("requestPOSTURL ===========>> " + urlString)
            print("request params===========>>")
            if params != nil {
                let paramsJSON = JSON(params!)
                
                print(paramsJSON)
            }
            print("request headers===========>>")
            let headersJSON = JSON(header)
            print(headersJSON)
            print("response===========>>")
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                let responseDictionary = resJson.dictionaryObject
                if let message = responseDictionary?[Constants.ResponseKeys.message] as? String, message == "Your session has been expired. Please logout and log back in." {
                    //UserManager.shared.deleteActiveUser()
                    AppDelegate.shared.presentRootViewController()
                }
                print(resJson)
                success(resJson)
            }
            if responseObject.result.isFailure {
                print(responseObject)
                let error: Error = responseObject.result.error!
                failure(error as NSError)
            }
        }
    }

    class func requestDELETEURL(_ urlString: String, params: [String: AnyObject]?, headers: [String: String]?, success: @escaping (JSON) -> Void, failure: @escaping (NSError) -> Void) {

        var header = headers ?? [String: String]()
        header["Version"] = Utilities.appVersion
        header["Build-Number"] = Utilities.buildNumber
        header["Device-Type"] = "ios"
        guard NetworkManager.isNetworkReachable() else {
            failure(Utilities.noInternetConnection())
            return
        }

        Alamofire.request(urlString, method: .delete, parameters: params, encoding: JSONEncoding.default, headers: header).responseString(completionHandler: { (response) in
            print("response String===========>>")
            print(response)
        }).responseJSON { (responseObject) -> Void in
            print("requestDELETEURL ===========>> " + urlString)
            if params != nil {
                let paramsJSON = JSON(params!)
                print("request params===========>>")
                print(paramsJSON)
            }
            
            let headersJSON = JSON(header)
            print("request headers===========>>")
            print(headersJSON)
            
            print("response===========>>")
            if responseObject.result.isSuccess {
                print(responseObject)
                let resJson = JSON(responseObject.result.value!)
                let responseDictionary = resJson.dictionaryObject
                if let message = responseDictionary?[Constants.ResponseKeys.message] as? String, message == "Your session has been expired. Please logout and log back in." {
                    //UserManager.shared.deleteActiveUser()
                    AppDelegate.shared.presentRootViewController()
                }
                success(resJson)
            }
            if responseObject.result.isFailure {
                print(responseObject)
                let error: Error = responseObject.result.error!
                failure(error as NSError)
            }
        }
    }

    class func uploadVideoWithMultipartFormData(_ urlString: String, params: [String: AnyObject]?, headers: [String: String]?, success: @escaping (JSON) -> Void, failure: @escaping (NSError) -> Void) {
        guard NetworkManager.isNetworkReachable() else {
            failure(Utilities.noInternetConnection())
            return
        }
        var header = headers ?? [String: String]()
        header["Version"] = Utilities.appVersion
        header["Build-Number"] = Utilities.buildNumber
        header["Device-Type"] = "ios"
        var filename = ""
        var minetype = ""
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in params! {
                if value is Data {
                    // multipartFormData.append(value as! Data, withName: key)
                    switch key {
                    case "image":
                        filename = "fileimage.jpg"
                        minetype = "image/jpg"
                    case "thumbnail", "videoThumbnail":
                        filename = "thumbnil.jpg"
                        minetype = "image/jpg"
                    case "video":
                        filename = "fileimage.m4v"
                        minetype = "video/*"
                    default:
                        break
                    }
                    multipartFormData.append(value as! Data, withName: key, fileName: filename, mimeType: minetype)
                } else {
                    let valueSTR = value as! String
                    multipartFormData.append(valueSTR.data(using: String.Encoding.utf8)!, withName: key)
                }
            }
        }, to: urlString, headers: header) { encodingResult in
            
            switch encodingResult {
            case let .success(upload, _, _):
                upload.responseJSON { (responseObject) -> Void in
                    print("request URL===========>> " + urlString)
                    if params != nil {
                        let paramsJSON = JSON(params!)
                        print("request params===========>>")
                        print(paramsJSON)
                    }
                    let headersJSON = JSON(header)
                    print("request headers===========>>")
                    print(headersJSON)
                    print("response===========>>")
                    if responseObject.result.isSuccess {
                        print(responseObject)
                        let resJson = JSON(responseObject.result.value!)
                        success(resJson)
                    }
                    if responseObject.result.isFailure {
                        print(responseObject)
                        let error: Error = responseObject.result.error!
                        failure(error as NSError)
                    }
                }
            case let .failure(encodingError):
                failure(encodingError as NSError)
            }
        }
        
        
    }
    
    class func uploadImageWithMultipartFormData(_ urlString: String, params: [String: AnyObject]?, headers: [String: String]?, success: @escaping (JSON) -> Void, failure: @escaping (NSError) -> Void) {

        guard NetworkManager.isNetworkReachable() else {
            failure(Utilities.noInternetConnection())
            return
        }
        var header = headers ?? [String: String]()
        header["Version"] = Utilities.appVersion
        header["Build-Number"] = Utilities.buildNumber
        header["Device-Type"] = "ios"
        let filename = "fileimage.jpg"
        let minetype = "image/jpg"
        

        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in params! {
                if value is Data {
                    // multipartFormData.append(value as! Data, withName: key)
                    multipartFormData.append(value as! Data, withName: key, fileName: filename, mimeType: minetype)
                } else {
                    if let valueSTR = value as? String {
                        multipartFormData.append(valueSTR.data(using: String.Encoding.utf8)!, withName: key)
                    }
                }
                
            }
        }, to: urlString, headers: header) { encodingResult in

            switch encodingResult {
            case let .success(upload, _, _):
                upload.responseJSON { (responseObject) -> Void in
                    print("request URL===========>> " + urlString)
                    if params != nil {
                        let paramsJSON = JSON(params!)
                        print("request params===========>>")
                        print(paramsJSON)
                    }
                    let headersJSON = JSON(header)
                    print("request headers===========>>")
                    print(headersJSON)
                    print("response===========>>")
                    if responseObject.result.isSuccess {
                        print(responseObject)
                        let resJson = JSON(responseObject.result.value!)
                        success(resJson)
                    }
                    if responseObject.result.isFailure {
                        print(responseObject)
                        let error: Error = responseObject.result.error!
                        failure(error as NSError)
                    }
                }
            case let .failure(encodingError):
                failure(encodingError as NSError)
            }
        }
    }

    class func requestPUTURL(_ urlString: String, params: [String: AnyObject]?, headers: [String: String]?, success: @escaping (JSON) -> Void, failure: @escaping (NSError) -> Void) {

        var header = headers ?? [String: String]()
        header["Version"] = Utilities.appVersion
        header["Build-Number"] = Utilities.buildNumber
        header["Device-Type"] = "ios"
        
        guard NetworkManager.isNetworkReachable() else {
            failure(Utilities.noInternetConnection())
            return
        }

        Alamofire.request(urlString, method: .put, parameters: params, encoding: JSONEncoding.default, headers: header).responseString(completionHandler: { (response) in
            print("response String===========>>")
            print(response)
        }).responseJSON { (responseObject) -> Void in
            print("request URL===========>> " + urlString)
            if params != nil {
                let paramsJSON = JSON(params!)
                print("request params===========>>")
                print(paramsJSON)
            }
            let headersJSON = JSON(header)
            print("request headers===========>>")
            print(headersJSON)
            print("response===========>>")
            if responseObject.result.isSuccess {
                print(responseObject)
                let resJson = JSON(responseObject.result.value!)
                let responseDictionary = resJson.dictionaryObject
                if let message = responseDictionary?[Constants.ResponseKeys.message] as? String, message == "Your session has been expired. Please logout and log back in." {
                    //UserManager.shared.deleteActiveUser()
                    AppDelegate.shared.presentRootViewController()
                }
                success(resJson)
            }
            if responseObject.result.isFailure {
                print(responseObject)
                let error: Error = responseObject.result.error!
                failure(error as NSError)
            }
        }
    }
}
