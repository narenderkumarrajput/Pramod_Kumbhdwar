//
//  AddJourneyRegViewController.swift
//  Kumbhdwar
//
//  Created by Narender Kumar on 19/03/21.
//  Copyright © 2021 Narender Kumar. All rights reserved.
//

import UIKit
import DropDown
import GooglePlaces

class AddJourneyRegViewController: UIViewController {
    
    @IBOutlet weak var nametxtFld: UITextField!
    @IBOutlet weak var numberOfPersonTxtFld: UITextField!
    @IBOutlet weak var vehicalNoTxtFld: UITextField!
    @IBOutlet weak var epassTxtFld: UITextField!
    @IBOutlet weak var selectDateTxtFild: UITextField!
    @IBOutlet weak var modeOfCommBtn: UIButton!
    @IBOutlet weak var destinationGhatBtn: UIButton!
    @IBOutlet weak var destinationParkingBtn: UIButton!
    @IBOutlet weak var placeBtn: UIButton!
    @IBOutlet weak var descTxtVw: UITextView!
    @IBOutlet weak var submitBtn: UIButton!
    
    var journeyPlanId: String = "0"
    
    let datePicker = UIDatePicker()
    let dropDown = DropDown()
    let dropDownGhat = DropDown() // "2,4"
    let dropDownPark = DropDown() // "6,8"
    private var latLong: (Double, Double) = (0.0, 0.0)
    private var selectPlaceString = "Select Place"
    private var selectModeString = "Select Mode Of Commute"
    private var selectGhatString = "Select Destination"
    private var selectParkingString = "Select Parking"
    private var param:[String: AnyObject] = [:]
    private var paramForOther:[String: AnyObject] = [:]
    private var modeOfCommArray: [ModeOfComm] = []
    private var selectModeOfComm: (Int, String) = (0, "")
    private var locationManager = CLLocationManager()
    private var placeGhat:[Place] = []
    private var placePark:[Place] = []
    
    private var selectedGhat: Place? = nil
    private var selectedPark: Place? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = AppStyleGuide.NewUI.Colors.appBg
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        self.navigationItem.title = "REGISTER"

       let button = UIButton(type: UIButton.ButtonType.custom)
       button.setImage(UIImage(named: "ic_arrow_back_white_24dp"), for: .normal)
       button.addTarget(self, action:#selector(AddJourneyRegViewController.backAction), for: .touchUpInside)
       button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
       let barButton = UIBarButtonItem(customView: button)
       self.navigationItem.leftBarButtonItems = [barButton]
        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshAction))
        refreshButton.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = refreshButton

        self.showDatePicker()
        self.placeBtn.setTitle(self.selectPlaceString, for: .normal)
        self.destinationGhatBtn.setTitle(self.selectGhatString, for: .normal)
        self.destinationParkingBtn.setTitle(self.selectParkingString, for: .normal)
        
        dropDown.anchorView = self.modeOfCommBtn
        let mode = ModeOfComm()
        mode.IsActive = false
        mode.MOCDId =  0
        mode.ModeOfCummute = selectModeString
        self.modeOfCommArray.append(mode)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getModeOfComm()
        self.showUserLocationOnMap()
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func showUserLocationOnMap() {
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        
        if CLLocationManager.locationServicesEnabled() {
            print("yes")
        }
        else {
            print("no")
        }
    }
    
    @objc func refreshAction() {
        nametxtFld.text = ""
        numberOfPersonTxtFld.text = ""
        vehicalNoTxtFld.text = ""
        epassTxtFld.text = ""
        selectDateTxtFild.text = ""
        descTxtVw.text = ""
        placeBtn.setTitle(self.selectPlaceString, for: .normal)
        modeOfCommBtn.setTitle(selectModeString, for: .normal)
        destinationGhatBtn.setTitle(selectGhatString, for: .normal)
        destinationParkingBtn.setTitle(selectParkingString, for: .normal)
    }
    
    private func showDatePicker() {
        //Formate Date
        
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        } else {
            // Fallback on earlier versions
        }
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
          let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
         let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));

        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        selectDateTxtFild.inputAccessoryView = toolbar
        selectDateTxtFild.inputView = datePicker
    }
    
    @objc func donedatePicker() {
     let formatter = DateFormatter()
     formatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss.SSS"
     selectDateTxtFild.text = formatter.string(from: datePicker.date)
     self.view.endEditing(true)
   }

   @objc func cancelDatePicker() {
      self.view.endEditing(true)
    }
    
    @IBAction func placeAction(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self

        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.placeID.rawValue) | UInt(GMSPlaceField.formattedAddress.rawValue) | UInt(GMSPlaceField.coordinate.rawValue))
        autocompleteController.placeFields = fields

        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        autocompleteController.autocompleteFilter = filter

        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func modeOfComAction(_ sender: Any) {
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            let obj = self.modeOfCommArray[index]
            self.selectModeOfComm = (obj.MOCDId, obj.ModeOfCummute)
            self.modeOfCommBtn.setTitle(item, for: .normal)
            
            self.self.dropDown.hide()
        }
    }
    
    @IBAction func destinationGhatAction(_ sender: Any) {
        let screenSize = UIScreen.main.bounds
        dropDownGhat.frame = CGRect(x: 20, y: 100, width: 350, height: 300)
        dropDownGhat.show()
        dropDownGhat.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            let obj = self.placeGhat[index]
            self.selectedGhat = obj
            self.destinationGhatBtn.setTitle(item, for: .normal)
            
            param["DestinationGhatName"] = obj.welcomeDescription as AnyObject
            param["DestinationGhatLat"] = obj.lat1 as AnyObject
            param["DestinationGhatLng"] = obj.lng1 as AnyObject
            
            
            self.self.dropDownGhat.hide()
        }
    }
    
    @IBAction func destinationParkingAction(_ sender: Any) {
        dropDownPark.show()
        dropDownPark.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            let obj = self.placePark[index]
            self.selectedPark = obj
            self.destinationParkingBtn.setTitle(item, for: .normal)
            
            param["ParkingName"] = obj.welcomeDescription as AnyObject
            param["ParkingLat"] = obj.lat1 as AnyObject
            param["ParkingLng"] = obj.lng1 as AnyObject
            
            self.self.dropDownPark.hide()
        }
    }

    @IBAction func submitAction(_ sender: UIButton) {
        let name = nametxtFld.text?.trimmed()
        if !(name != nil && (name!.count) > 0) {
            self.showAlertWithOk(title: "Info", message: "Please enter your name")
            return
        }
        param["VisitorName"] = name as AnyObject?
        param["VisitorId"] = UserManager.shared.activeUser.UHouseId as AnyObject?
        
        let numberOfPerson = numberOfPersonTxtFld.text?.trimmed()
        if !(numberOfPerson != nil && (numberOfPerson!.count) > 0) {
            self.showAlertWithOk(title: "Info", message: "Please enter number of person")
            return
        }
        param["AccompanyingPersons"] = numberOfPerson as AnyObject?
        
        let vehicalNo = vehicalNoTxtFld.text?.trimmed()
        if !(vehicalNo != nil && (vehicalNo!.count) > 0) {
            self.showAlertWithOk(title: "Info", message: "Please enter vehicle number")
            return
        }
        param["VehicleNo"] = vehicalNo as AnyObject?
        
        let epass = epassTxtFld.text?.trimmed()
        if !(epass != nil && (epass!.count) > 0) {
            self.showAlertWithOk(title: "Info", message: "Please enter e-pass number")
            return
        }
        param["ePass"] = epass as AnyObject?
        
        let date = selectDateTxtFild.text?.trimmed()
        if !(date != nil && (date!.count) > 5) {
            self.showAlertWithOk(title: "Info", message: "Please select date")
            return
        }
        param["VisitingDate"] = selectDateTxtFild.text as AnyObject?
        
        if self.selectModeOfComm.0 == 0 {
            self.showAlertWithOk(title: "Info", message: "Please select mode of commute")
            return
        }
        param["TravelMode"] = String(self.selectModeOfComm.0) as AnyObject
        
        let place = placeBtn.titleLabel?.text
        if place == selectPlaceString {
            self.showAlertWithOk(title: "Info", message: "Please select a place")
            return
        }
        param["SourceAddress"] = place as AnyObject
        param["SourceLat"] = String(latLong.0) as AnyObject
        param["SourceLng"] = String(latLong.1) as AnyObject
        param["Remark"] = descTxtVw.text as AnyObject
        
        //destinationGhatBtn.setTitle(selectGhatString, for: .normal)
        //destinationParkingBtn.setTitle(selectParkingString, for: .normal)
        
        let ghat = destinationGhatBtn.titleLabel?.text
        if ghat == selectGhatString {
            self.showAlertWithOk(title: "Info", message: "Please select a \(selectGhatString)")
            return
        }
        
        let parking = destinationParkingBtn.titleLabel?.text
        if parking == selectParkingString {
            self.showAlertWithOk(title: "Info", message: "Please select a \(selectParkingString)")
            return
        }
        
        self.submit()
    }
    
}



extension AddJourneyRegViewController: GMSAutocompleteViewControllerDelegate {

  // Handle the user's selection.
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    print("Place formattedAddress: \(place.formattedAddress ?? "")")
    print("Place name: \(place.name ?? "")")
    print("Place ID: \(place.placeID ?? "")")
    print("Place attributions: \(place.attributions)")
    
    latLong = (place.coordinate.latitude, place.coordinate.longitude)
    self.placeBtn.setTitle(("\(place.name ?? place.formattedAddress ?? self.selectPlaceString)"), for: .normal)
    
    dismiss(animated: true, completion: nil)
  }

  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }

  // User canceled the operation.
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
    self.placeBtn.setTitle(self.selectPlaceString, for: .normal)
  }

  // Turn the network activity indicator on and off again.
  func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
  }

  func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }

}



extension AddJourneyRegViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.startUpdatingLocation()

            case .denied:
                print("Location permission denied")
                self.showAlertWithOk(title: "Info", message: "Please go to Settings and turn on Location Service for this app.")

            case .restricted:
                print("Location permission restricted")
                self.showAlertWithOk(title: "Info", message: "Please go to Settings and turn on Location Service for this app.")

            case .notDetermined:
                print("Location permission notDetermined")
                self.showAlertWithOk(title: "Info", message: "Please go to Settings and turn on Location Service for this app.")

            @unknown default: break
                //fatalError()
            }
        }
    
    //Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        self.locationManager.stopUpdatingLocation()
        
        paramForOther["SearchText"] = "" as AnyObject
        paramForOther["PageNo"] = "0" as AnyObject
        paramForOther["PageSize"] = "2000" as AnyObject
        paramForOther["Lat"] = String(location!.coordinate.latitude) as AnyObject
        paramForOther["Lng"] = String(location!.coordinate.longitude) as AnyObject
        
        self.showPlacesGhat()
        self.showPlacesParking()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("issue in get location")
    }
    
}


extension AddJourneyRegViewController {
    
    private func getModeOfComm() {
        Utility.showLoaderWithTextMsg(text: "")
        NetworkManager.requestGETURL(Constants.APIServices.ModeOfCommute, headers: nil, params: [:], success: { (responseJSON) in
            Utility.hideLoader()
            let responseDictionary = responseJSON.arrayObject
            print(responseDictionary)
            if let _ = responseDictionary {
                if responseDictionary!.count > 0 {
                    var arr: [String] = []
                    arr.append(self.selectModeString)
                    for (_, val) in responseDictionary!.enumerated() {
                        let temp = val as! [String : AnyObject]
                        let mode = ModeOfComm()
                        mode.IsActive = temp["IsActive"] as? Bool ?? false
                        mode.MOCDId = temp["MOCDId"] as? Int ?? 0
                        mode.ModeOfCummute = temp["ModeOfCummute"] as? String ?? ""
                        
                        self.modeOfCommArray.append(mode)
                        arr.append(mode.ModeOfCummute)
                    }
                    
                    self.dropDown.dataSource = arr
                    self.dropDown.reloadAllComponents()
                }
            }
        }) { (error) in
            Utility.hideLoader()
            self.showAlertWithOk(title: "Error", message: error.localizedFailureReason)
        }
    }
    
    
    private func showPlacesGhat() {
        
        /*
         "SearchText":"",
         "PageNo":"0",
         "PageSize":"100",
         "AmenityTypeId":"5",
         "Lat":"30.1135881988418",
         "Lng":"78.2953164893311"
         */
        
        self.paramForOther["AmenityTypeId"] = "2,4" as AnyObject
        
        NetworkManager.requestPOSTURL(Constants.APIServices.DataById, params: self.paramForOther, headers: nil, success: { (responseJSON) in
            Utility.hideLoader()
            let responseArray = responseJSON.arrayObject!
            if responseArray.count > 0 {
                self.placeGhat.removeAll()
                var arr: [String] = []
                for obj in responseArray {
                    let temp = obj as! [String: Any]
                    let rowNumber = temp["RowNumber"] as? Int
                    let totalCount = temp["TotalCount"] as? Int
                    let amenityGeoID = temp["AmenityGeoId"] as? Int
                    let amenityTypeID = temp["AmenityTypeId"] as? Int
                    let sType  = temp["SType"] as? String
                    let welcomeDescription = temp["Description"] as? String
                    let amenityType = temp["AmenityType"] as? String
                    let lat1 = temp["Lat1"] as? String
                    let lng1 = temp["Lng1"] as? String
                    let fuRL = temp["fuRL"] as? String
                    let distance = temp["Distance"] as? Double
                    
                    let place = Place(rowNumber: rowNumber ?? 0, totalCount: totalCount ?? 0, amenityGeoID: amenityGeoID ?? 0, amenityTypeID: amenityTypeID ?? 0, sType: sType ?? "", welcomeDescription: welcomeDescription ?? "", amenityType: amenityType ?? "", lat1: lat1 ?? "", lng1: lng1 ?? "", fuRL: fuRL ?? "" , distance: distance ?? 0.0)
                    
                    self.placeGhat.append(place)
                    arr.append(welcomeDescription ?? "")
                }
                self.dropDownGhat.dataSource = arr
                self.dropDownGhat.reloadAllComponents()
                
            } else {
                self.showAlertWithOk(title: "Info", message: "There is some issue. Please try after some time")
            }
        }) { (error) in
            print(error)
            Utility.hideLoader()
            self.showAlertWithOk(title: "Error", message: "User not found")
        }
    }
    
    
    private func showPlacesParking() {
        
        /*
         "SearchText":"",
         "PageNo":"0",
         "PageSize":"100",
         "AmenityTypeId":"5",
         "Lat":"30.1135881988418",
         "Lng":"78.2953164893311"
         */
        
        self.paramForOther["AmenityTypeId"] = "6,8" as AnyObject
        Utility.showLoaderWithTextMsg(text: "")
        
        NetworkManager.requestPOSTURL(Constants.APIServices.DataById, params: self.paramForOther, headers: nil, success: { (responseJSON) in
            Utility.hideLoader()
            let responseArray = responseJSON.arrayObject!
            if responseArray.count > 0 {
                self.placePark.removeAll()
                var arr: [String] = []
                for obj in responseArray {
                    let temp = obj as! [String: Any]
                    let rowNumber = temp["RowNumber"] as? Int
                    let totalCount = temp["TotalCount"] as? Int
                    let amenityGeoID = temp["AmenityGeoId"] as? Int
                    let amenityTypeID = temp["AmenityTypeId"] as? Int
                    let sType  = temp["SType"] as? String
                    let welcomeDescription = temp["Description"] as? String
                    let amenityType = temp["AmenityType"] as? String
                    let lat1 = temp["Lat1"] as? String
                    let lng1 = temp["Lng1"] as? String
                    let fuRL = temp["fuRL"] as? String
                    let distance = temp["Distance"] as? Double
                    
                    let place = Place(rowNumber: rowNumber ?? 0, totalCount: totalCount ?? 0, amenityGeoID: amenityGeoID ?? 0, amenityTypeID: amenityTypeID ?? 0, sType: sType ?? "", welcomeDescription: welcomeDescription ?? "", amenityType: amenityType ?? "", lat1: lat1 ?? "", lng1: lng1 ?? "", fuRL: fuRL ?? "" , distance: distance ?? 0.0)
                    
                    self.placePark.append(place)
                    arr.append(welcomeDescription ?? "")
                    
                }
                self.dropDownPark.dataSource = arr
                self.dropDownPark.reloadAllComponents()
            } else {
                self.showAlertWithOk(title: "Info", message: "There is some issue. Please try after some time")
            }
        }) { (error) in
            print(error)
            Utility.hideLoader()
            self.showAlertWithOk(title: "Error", message: "User not found")
        }
    }
    
    func submit() {
        
        Utility.showLoaderWithTextMsg(text: "")
        self.param["JourneyPlanId"] = journeyPlanId as AnyObject
        NetworkManager.requestPOSTURL(Constants.APIServices.saveJourney, params: self.param, headers: nil, success: { (responseJSON) in
            Utility.hideLoader()
            let responseDictionary = responseJSON.dictionaryObject!
            if let msg = responseDictionary["Result"] as? String {
                if msg == "1" || msg == "2"{
                    let alert = UIAlertController(title: "Info", message: "Your Journey plan save successfully.", preferredStyle: UIAlertController.Style.alert)
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
                        self.backAction()
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                    
                } else {
                    self.showAlertWithOk(title: "Info", message: "There is some issue. Please try after some time")
                }
            } else {
                self.showAlertWithOk(title: "Info", message: "There is some issue. Please try after some time")
            }
        }) { (error) in
            print(error)
            Utility.hideLoader()
            self.showAlertWithOk(title: "Error", message: error.localizedDescription)
        }
        
        
    }
    
    
}
