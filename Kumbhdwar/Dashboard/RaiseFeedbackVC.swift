//
//  RaiseFeedbackVC.swift
//  Kumbhdwar
//
//  Created by Peoplelink on 3/17/21.
//  Copyright © 2021 Narender Kumar. All rights reserved.
//

import UIKit
import DropDown
import MapKit
import CoreLocation
import Alamofire
import SwiftyJSON

class RaiseFeedbackVC: UIViewController {

    @IBOutlet weak var selectCategoryView: UIView!
    @IBOutlet weak var selectCategoryButton: UIButton!
    @IBOutlet weak var descriptionextView: UITextView!
    @IBOutlet weak var defaultPic: UIImageView!
    @IBOutlet weak var addedImage: UIImageView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var addPhotoView: UIView!
    @IBOutlet weak var addComplaintDataLangText: UILabel!
    @IBOutlet weak var addFeedbackLangText: UILabel!
    @IBOutlet weak var attachPhotoLangText: UILabel!
    @IBOutlet weak var attachingAPhotoLangText: UILabel!
    
    let dropDown = DropDown()
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var selectedIndex = 0
    var selectedImage: UIImage?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupDropDown()
        setupLocationManager()
    }
    
    
    func setupUI() {
        self.descriptionextView.borderWithColor(enable: true, withRadius: 10.0, width: 1.0, color: UIColor(named: "PrimaryColor") ?? .red)
        self.submitButton.borderWithColor(enable: true, withRadius: 10.0, width: 1.0, color: UIColor(named: "PrimaryColor") ?? .red)
        self.addPhotoView.borderWithColor(enable: true, withRadius: 10.0, width: 1.0, color: UIColor(named: "PrimaryColor") ?? .red)
        self.selectCategoryView
            .borderWithColor(enable: true, withRadius: 0.0, width: 1.0, color: UIColor(named: "PrimaryColor") ?? .red)
        self.descriptionextView.textColor = .gray
        self.descriptionextView.text = "Description"
        self.descriptionextView.delegate = self
        
    }
    
    func setupDropDown() {
        dropDown.anchorView = self.selectCategoryButton // UIView or UIBarButtonItem
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = ["Select Category","TOILET CLEAN", "CHANGING ROOM", "SANITAION POINT"]
        dropDown.width = selectCategoryButton.frame.width - 80
        dropDown.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        DropDown.appearance().textColor = .black
        DropDown.appearance().backgroundColor = UIColor.white

    }
    
    func setupLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways) {
            
            if CLLocationManager.locationServicesEnabled() {
//                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
                guard let currentLocation = locationManager.location else {
                    return
                }
                self.currentLocation = currentLocation
//                getParkingDetails(location: currentLocation, amenityId: amenityTypeId)
            }
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectCategoryButtonTapped(_ sender: UIButton) {
        dropDown.show()
        // Action triggered on selection
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.selectedIndex = index
          print("Selected item: \(item) at index: \(index)")
            self.selectCategoryButton.setTitle(item, for: .normal)
            self.self.dropDown.hide()
        }
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        addComplaint()
    }

    @IBAction func attachPhotoTapped(_ sender: UIButton) {
        #if targetEnvironment(simulator)
        self.addedImage.image = #imageLiteral(resourceName: "iTunesArtwork")
        selectedImage = #imageLiteral(resourceName: "iTunesArtwork")
        #else
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
        #endif
        
    }
    
    private func addComplaint() {
        guard let contactNo = UserManager.shared.activeUser.CNO else { successLabel(view: self.view, message: "Something is wrong with your contact number", completion: nil); return }
        if selectedIndex == 0 {
            successLabel(view: self.view, message: "Please Select Category", completion: nil); return
        }
        if descriptionextView.textColor == UIColor.gray {
            successLabel(view: self.view, message: "Please enter remark", completion: nil); return
        }
        guard let image = selectedImage else {successLabel(view: view, message: "Please add Photo", completion: nil); return }
        
        let headers = ["Authorization":"Basic cGF0bmE6cGF0bmEjMjAyMA=="] as [String:String]
        
        let latitude = "\(currentLocation.coordinate.latitude)"
        let longitude = "\(currentLocation.coordinate.longitude)"
        Utility.showLoaderWithTextMsg(text: "Loading...")
        
        let jsonDictionary = [
            "Complaint": descriptionextView.text ?? "" ,
            "CategoryId": "\(selectedIndex)",
            "Lat": latitude.count > 0 ? latitude : "0",
            "Lng":longitude.count > 0 ? longitude : "0",
            "ContactNo": contactNo,
            "UHouseId":""
        ] as [String: Any]
        let parameters = ["Input": jsonToString(json: jsonDictionary)]
        let urlString = Constants.APIServices.addComplaint
        let imageData = image.jpegData(compressionQuality: 0.50) ?? Data()

        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "image \(Date())", fileName: "file\(Date()).jpg", mimeType: "image/jpg")
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: urlString, headers: headers) { (result) in
            
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { (responseObject) -> Void in
                    Utility.hideLoader()
                    if responseObject.result.isSuccess {
                        print(responseObject)
                        let resJson = JSON(responseObject.result.value!)
                        print(resJson)
                        DispatchQueue.main.async {
                            self.successLabel(view: self.view, message: "Succesfully uploaded") { (isSuccess) in
                                if isSuccess {
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }

                        }
                    }
                    if responseObject.result.isFailure {
                        print(responseObject)
                        let error: Error = responseObject.result.error!
//                        failure(error as NSError)
                        print(error)
                    }
                }
            case .failure(let error):
                Utility.hideLoader()
                print("error is\(error)")
            }
            print("result\(result)")
        }
        
        
    }
    
    func jsonToString(json: [String: Any]) -> String {
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
            print(convertedString ?? "defaultvalue")

            return convertedString ?? ""
        } catch let myJSONError {
            print(myJSONError)
        }
        return ""
        
    }
}

extension RaiseFeedbackVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }

        self.addedImage.image = image
        selectedImage = image

        print(image.size)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.gray {
            textView.text = nil
            textView.textColor = UIColor(named: "PrimaryColor") ?? .red
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Description"
            textView.textColor = UIColor.gray
        }

    }
    
    func successLabel(view: UIView, message: String, completion: ((Bool) -> Void)?) {
        
        let backgroundView = UIView(frame: CGRect(x: 50, y: view.frame.size.height - 150, width: view.frame.size.width - 80, height: 50))
        
        backgroundView.backgroundColor = #colorLiteral(red: 0.2784313725, green: 0.2784313725, blue: 0.2784313725, alpha: 1)
        backgroundView.round(enable: true, withRadius: nil)
        
        let label = UILabel(frame: CGRect(x: backgroundView.frame.origin.x + 5, y: backgroundView.frame.origin.y, width: backgroundView.frame.width - 10, height: 50))
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = message
        label.numberOfLines = 3
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        view.addSubview(backgroundView)
        view.addSubview(label)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            backgroundView.removeFromSuperview()
            label.removeFromSuperview()
            completion?(true)
        }
        
    }
}
