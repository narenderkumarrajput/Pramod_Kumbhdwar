//
//  Utilities.swift
//
//  Created by Arvind Singh on 13/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import Photos
import MapKit

let screenBounds = UIScreen.main.bounds
let screenSize = screenBounds.size
let screenWidth = screenSize.width
let screenHeight = screenSize.height
let gridWidth: CGFloat = (screenSize.width / 2) - 20.0
let navigationHeight: CGFloat = 44.0
let statubarHeight: CGFloat = 20.0
let navigationHeaderAndStatusbarHeight: CGFloat = navigationHeight + statubarHeight


class Utilities {
    /**
     Global function to check if the input object is initialized or not.

     - parameter value: value to verify for initialization

     - returns: true if initialized
     */
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

    static let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    
    static func isObjectInitialized(_ value: AnyObject?) -> Bool {
        guard value != nil else {
            return false
        }
        return true
    }

    // Global variables
    static var defaultAPIServiceHeaders: [String: String] {
        var headers: [String: String] = [String: String]()
        headers["Accept"] = "application/json"
        headers["Content-Type"] = "application/json"
        return headers
    }

    static var defaultAPIServiceParameters: [String: Any] {
        var parameters: [String: Any] = [String: Any]()
        parameters["deviceType"] = 1
        //parameters["deviceToken"] = AppDelegate.shared.deviceToken
        return parameters
    }
    
    class func handleErrorResponse(_ message: String, viewController: UIViewController) {
        let tempMessage = (message == Constants.ErrorMessages.networkError && NetworkManager.isNetworkReachable() == false) ? Constants.ErrorMessages.networkDisconnected : message
        let alertController = UIAlertController(title: Constants.AlertTitles.errorTitle, message: tempMessage, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .cancel) { (_: UIAlertAction!) in
            // we don't want to perform any action on cancel
        }
        alertController.addAction(cancelAction)
        
        if message == Constants.ErrorMessages.sessionExpireError  {
            UserManager.shared.userLogout()
            AppDelegate.shared.presentRootViewController()
        } else {
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    fileprivate class func getMaxHeightWidth() -> (maxHeight: CGFloat, maxWidth: CGFloat) {
        let maxHeight: CGFloat = 1334.0
        let maxWidth: CGFloat = 750.0
        return (maxHeight, maxWidth)
    }
    class func noInternetConnection() -> NSError {
        
        let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: [NSLocalizedFailureReasonErrorKey: Constants.ErrorMessages.networkDisconnected])
        print(error.localizedDescription)
        return error
    }
    class func resizeForUploadPNG(sourceImage: UIImage) -> NSData? {
        
        var finalData: NSData?
        
        var maxHeight: CGFloat
        var maxWidth: CGFloat
        maxHeight = 796.0
        maxWidth = 450.0
        
        var actualHeight: CGFloat = sourceImage.size.height
        var actualWidth: CGFloat = sourceImage.size.width
        
        var imageRatio: CGFloat = actualWidth / actualHeight
        
        let maxRatio: CGFloat = maxWidth / maxHeight
        
        if actualHeight > maxHeight || actualWidth > maxWidth {
            
            if imageRatio < maxRatio { // adjust width according to maxHeight
                
                imageRatio = maxHeight / actualHeight
                actualWidth = imageRatio * actualWidth
                actualHeight = maxHeight
            } else if imageRatio > maxRatio { // adjust height according to maxWidth
                
                imageRatio = maxWidth / actualWidth
                actualHeight = imageRatio * actualHeight
                actualWidth = maxWidth
            } else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        
        finalData = sourceImage.pngData()! as NSData
        
        return finalData
    }
    class func imageWith(sourceImage: UIImage, newSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let image = renderer.image { _ in
            sourceImage.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        }
        return image
    }
    
    class func compressVideo(inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?,_ compressedData: Data)-> Void) {
        guard let data = NSData(contentsOf: inputURL as URL) else {
            return
        }
        
        print("File size before compression: \(Double(data.length / 1024000)) mb")
        
        exportVideo(inputURL: inputURL as URL, outputURL: outputURL) { (exportSession) in
            guard let session = exportSession else {
                return
            }
            switch session.status {
            case .unknown:
                break
            case .waiting:
                break
            case .exporting:
                break
            case .completed:
                
                do {
                    let compressedData = try Data(contentsOf: outputURL)
                    print("File size after compression: \(Double(compressedData.count / 1024000)) mb")
                    handler(session, compressedData)
                } catch {
                    print("error on compression", error.localizedDescription)
                }
            case .failed:
                break
            case .cancelled:
                break
            }
        }
    }
    
    class func generateThumbnail(path: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: path, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }

    class func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void)) {
        DispatchQueue.global().async { //1
            let asset = AVAsset(url: url) //2
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
            avAssetImageGenerator.appliesPreferredTrackTransform = true //4
            let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
                let thumbImage = UIImage(cgImage: cgThumbImage) //7
                DispatchQueue.main.async { //8
                    completion(thumbImage) //9
                }
            } catch {
                print(error.localizedDescription) //10
                DispatchQueue.main.async {
                    completion(nil) //11
                }
            }
        }
    }
    
    class func exportVideo(inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetMediumQuality) else {
            handler(nil)
            
            return
        }
        
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mov
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.exportAsynchronously { () -> Void in
            handler(exportSession)
        }
    }
    
    class func resizeForUploadJPEG(sourceImage: UIImage) -> NSData {
        
        let constBytesInMB: Int = 1048576
        let sizeInMB: Int = 1
        
        // Step 1 - scale down the source image to have 1/3rd compression
        var unscaledData: NSData? = sourceImage.jpegData(compressionQuality: 0.25)! as NSData
        let scaledDownImage = UIImage(data: unscaledData! as Data)
        
        var finalData: NSData = unscaledData!
        
        var counter: Int = 0 // to ensure repeat loop only works for 4 times at max
        
        var actualHeight: CGFloat = sourceImage.size.height
        var actualWidth: CGFloat = sourceImage.size.width
        
        var maxHeight: CGFloat
        var maxWidth: CGFloat
        
        let maxHeightWidth = getMaxHeightWidth()
        maxHeight = maxHeightWidth.maxHeight
        maxWidth = maxHeightWidth.maxWidth
        
        // Step 2 - resize & scale image keeping aspect ratio to match the required frame size
        repeat {
            
            if finalData.length > (sizeInMB * constBytesInMB) / 4 { // do not execute if image size is less than the target size i.e. 262kb approx
                
                var imageRatio: CGFloat = actualWidth / actualHeight
                let maxRatio: CGFloat = maxWidth / maxHeight
                
                if actualHeight > maxHeight || actualWidth > maxWidth {
                    
                    if imageRatio < maxRatio { // adjust width according to maxHeight
                        
                        imageRatio = maxHeight / actualHeight
                        actualWidth = imageRatio * actualWidth
                        actualHeight = maxHeight
                    } else if imageRatio > maxRatio { // adjust height according to maxWidth
                        
                        imageRatio = maxWidth / actualWidth
                        actualHeight = imageRatio * actualHeight
                        actualWidth = maxWidth
                    } else {
                        actualHeight = maxHeight
                        actualWidth = maxWidth
                    }
                }
                
                if counter > 0 { // in case repeat loop
                    actualWidth -= 100
                    actualHeight -= 100
                }
                
                // let scaledImage: UIImage = self.imageWithImage(image: sourceImage, width: actualWidth, height: actualHeight)
                let resizedImage = imageWith(sourceImage: scaledDownImage!, newSize: CGSize(width: actualWidth, height: actualHeight))
                finalData = resizedImage.jpegData(compressionQuality: 0.825)! as NSData
                
            } else {
                break
            }
            counter += 1
            
        } while (counter <= 3 && finalData.length > (sizeInMB * constBytesInMB) / 4)
        
        unscaledData = nil
        print("resized upload image size (JPEG) in bytes = \(String(describing: finalData.length))")
        return finalData
    }
    
    class func resizeForUploadPNG(sourceImage: UIImage) -> NSData {
        
        let constBytesInMB: Int = 1048576
        let sizeInMB: Int = 2
        
        // Step 1 - scale down the source image to have 1/3rd compression
        var unscaledData: NSData? = sourceImage.pngData()! as NSData
        let scaledDownImage = UIImage(data: unscaledData! as Data)
        
        var finalData: NSData = unscaledData!
        
        var counter: Int = 0 // to ensure repeat loop only works for 4 times at max
        
        var actualHeight: CGFloat = sourceImage.size.height
        var actualWidth: CGFloat = sourceImage.size.width
        
        var maxHeight: CGFloat
        var maxWidth: CGFloat
        
        let maxHeightWidth = getMaxHeightWidth()
        maxHeight = maxHeightWidth.maxHeight
        maxWidth = maxHeightWidth.maxWidth
        
        // Step 2 - resize & scale image keeping aspect ratio to match the required frame size
        repeat {
            
            if finalData.length > (sizeInMB * constBytesInMB) / 4 { // do not execute if image size is less than the target size i.e. 262kb approx
                
                var imageRatio: CGFloat = actualWidth / actualHeight
                let maxRatio: CGFloat = maxWidth / maxHeight
                
                if actualHeight > maxHeight || actualWidth > maxWidth {
                    
                    if imageRatio < maxRatio { // adjust width according to maxHeight
                        
                        imageRatio = maxHeight / actualHeight
                        actualWidth = imageRatio * actualWidth
                        actualHeight = maxHeight
                    } else if imageRatio > maxRatio { // adjust height according to maxWidth
                        
                        imageRatio = maxWidth / actualWidth
                        actualHeight = imageRatio * actualHeight
                        actualWidth = maxWidth
                    } else {
                        actualHeight = maxHeight
                        actualWidth = maxWidth
                    }
                }
                
                if counter > 0 { // in case repeat loop
                    actualWidth -= 100
                    actualHeight -= 100
                }
                
                // let scaledImage: UIImage = self.imageWithImage(image: sourceImage, width: actualWidth, height: actualHeight)
                let resizedImage = imageWith(sourceImage: scaledDownImage!, newSize: CGSize(width: actualWidth, height: actualHeight))
                finalData = resizedImage.pngData()! as NSData
                
            } else {
                break
            }
            counter += 1
            
        } while (counter <= 3 && finalData.length > (sizeInMB * constBytesInMB) / 4)
        
        unscaledData = nil
        print("resized upload image size (PNG) in bytes = \(String(describing: finalData.length))")
        return finalData
    }
    
    class func extractYouTubeId(from url: String) -> String? {
        let typePattern = "(?:(?:\\.be\\/|embed\\/|v\\/|\\?v=|\\&v=|\\/videos\\/)|(?:[\\w+]+#\\w\\/\\w(?:\\/[\\w]+)?\\/\\w\\/))([\\w-_]+)"
        let regex = try? NSRegularExpression(pattern: typePattern, options: .caseInsensitive)
        return regex
            .flatMap { $0.firstMatch(in: url, range: NSMakeRange(0, url.count)) }
            .flatMap { Range($0.range(at: 1), in: url) }
            .map { String(url[$0]) }
    }
    class func setStatusBar(){
        if #available(iOS 13, *)
        {
            if let frame = UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame {
                let statusBar = UIView(frame: frame)
                statusBar.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.231372549, blue: 0, alpha: 1)
                UIApplication.shared.keyWindow?.addSubview(statusBar)
            }
        }
    }
    
}
