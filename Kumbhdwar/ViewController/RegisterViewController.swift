//
//  RegisterViewController.swift
//  Kumbhdwar
//
//  Created by Narender Kumar on 14/03/21.
//  Copyright © 2021 Narender Kumar. All rights reserved.
//

import UIKit
import DropDown
import GooglePlaces

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var phoneTxtFild: UITextField!
    @IBOutlet weak var nameTxtFild: UITextField!
    @IBOutlet weak var passwordTxtFild: UITextField!
    @IBOutlet weak var vehicleNoTxtFild: UITextField!
    @IBOutlet weak var epassTxtFild: UITextField!
    @IBOutlet weak var selectDateTxtFild: UITextField!
    @IBOutlet weak var modeOfComBtn: UIButton!
    @IBOutlet weak var placeBtn: UIButton!
    @IBOutlet weak var otpTxtFild: UITextField!
    @IBOutlet weak var changeIconButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    let datePicker = UIDatePicker()
    var iconClick = true
    let dropDown = DropDown()
    private var selectModeOfComm: (Int, String) = (0, "")
    private var selectPlaceString = "Select Place"
    private var latLong: (Double, Double) = (0.0, 0.0)
    private var selectModeString = "Select Mode Of Commute"
    private var param:[String: AnyObject] = [:]
    private var modeOfCommArray: [ModeOfComm] = []
    var isSelectedIcon = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = AppStyleGuide.NewUI.Colors.appBg
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        self.navigationItem.title = "REGISTER"

       let button = UIButton(type: UIButton.ButtonType.custom)
       button.setImage(UIImage(named: "ic_arrow_back_white_24dp"), for: .normal)
       button.addTarget(self, action:#selector(RegisterViewController.backAction), for: .touchUpInside)
       button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
       let barButton = UIBarButtonItem(customView: button)
       self.navigationItem.leftBarButtonItems = [barButton]

        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshAction))
        refreshButton.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = refreshButton
        registerButton.isUserInteractionEnabled = false
        
        self.addLeftButtonOn(self.passwordTxtFild)
        self.passwordTxtFild.isSecureTextEntry = true
        self.showDatePicker()
        
        // The view to which the drop down will appear on
        dropDown.anchorView = self.modeOfComBtn // UIView or UIBarButtonItem
        // The list of items to display. Can be changed dynamically
        //dropDown.dataSource = [selectModeString, "TRAIN", "BUS", "TAXI", "PERSONAL VEHICLE"]
        let mode = ModeOfComm()
        mode.IsActive = false
        mode.MOCDId =  0
        mode.ModeOfCummute = selectModeString
        self.modeOfCommArray.append(mode)
        self.placeBtn.setTitle(self.selectPlaceString, for: .normal)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getModeOfComm()
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func refreshAction() {
        
        phoneTxtFild.text = ""
        nameTxtFild.text = ""
        passwordTxtFild.text = ""
        vehicleNoTxtFild.text = ""
        epassTxtFild.text = ""
        selectDateTxtFild.text = ""
        modeOfComBtn.setTitle(selectModeString, for: .normal)
        placeBtn.setTitle(self.selectPlaceString, for: .normal)
        otpTxtFild.text = ""
    }
    
    private func addLeftButtonOn(_ textField: UITextField) {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "eye.png"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(textField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action: #selector(self.showPassword), for: .touchUpInside)
        textField.rightView = button
        textField.rightViewMode = .always
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
    
    @IBAction func showPassword(_ sender: Any) {
        if(iconClick == true) {
            passwordTxtFild.isSecureTextEntry = false
        } else {
            passwordTxtFild.isSecureTextEntry = true
        }

        iconClick = !iconClick
    }
    @IBAction func changeIconButton(_ sender: Any) {
        if isSelectedIcon == false {
            changeIconButton.setImage(#imageLiteral(resourceName: "fillSquare"), for: .normal)
            registerButton.isUserInteractionEnabled = true
            isSelectedIcon = true
        } else {
            changeIconButton.setImage(#imageLiteral(resourceName: "stop"), for: .normal)
            registerButton.isUserInteractionEnabled = false
            isSelectedIcon = false
        }
    }
    
    @IBAction func termsAndConditionsButtonTapped(_ sender: UIButton) {
        guard let termsAndConditions = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TermsAndConditionsVC") as? TermsAndConditionsVC else { return }
        self.navigationController?.pushViewController(termsAndConditions, animated: true)
    }
    @IBAction func selectDateAction(_ sender: Any) {
        self.showDatePicker()
    }
    
    @IBAction func modeOfComAction(_ sender: Any) {
        dropDown.show()
        // Action triggered on selection
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            let obj = self.modeOfCommArray[index]
            self.selectModeOfComm = (obj.MOCDId, obj.ModeOfCummute)
            self.modeOfComBtn.setTitle(item, for: .normal)
            
            self.self.dropDown.hide()
        }
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
    
    @IBAction func otpAction(_ sender: Any) {
        self.registorAction(sender)
    }
    
    @IBAction func registorAction(_ sender: Any) {
        /*
         "ContactNo":"00000",
         "Name":"Raj",
         "Pwd":"raj@123",
         "VehicleNo":"", -----
         "HasEPass":0,
         "EPassNo":"" -------
         */
     
        let phone = phoneTxtFild.text?.trimmed()
        if !(phone != nil && (phone!.count) > 0) {
            self.showAlertWithOk(title: "Info", message: "Please enter phone number")
            return
        }
        param["ContactNo"] = phone as AnyObject?
        
        let name = nameTxtFild.text?.trimmed()
        if !(name != nil && (name!.count) > 0) {
            self.showAlertWithOk(title: "Info", message: "Please enter your name")
            return
        }
        param["Name"] = name as AnyObject?
        
        let password = passwordTxtFild.text?.trimmed()
        if !(password != nil && (password!.count) > 0) {
            self.showAlertWithOk(title: "Info", message: "Please enter password")
            return
        }
        param["Pwd"] = password as AnyObject?
        
        param["VehicleNo"] = "" as AnyObject?
        if vehicleNoTxtFild.text?.count ?? 0 > 0 {
            param["VehicleNo"] = vehicleNoTxtFild.text as AnyObject?
        }
        
        param["EPassNo"] = "" as AnyObject?
        param["HasEPass"] = 0 as AnyObject?
        if epassTxtFild.text?.count ?? 0 > 0 {
            param["EPassNo"] = epassTxtFild.text as AnyObject?
            param["HasEPass"] = 1 as AnyObject?
        }
        /*
        "DateOfVisit":"2021-03-27T11:28:42",
        "ModeOfCommuteId":"1",
        "Location":"Noida",
        "Lat":"0.0",
        "Lng":"0.0",
        "Otp":"000000",
        "HasOtp":1,
         */
        
        let date = selectDateTxtFild.text?.trimmed()
        if !(date != nil && (date!.count) > 5) {
            self.showAlertWithOk(title: "Info", message: "Please select date")
            return
        }
        param["DateOfVisit"] = selectDateTxtFild.text as AnyObject?
        
        if self.selectModeOfComm.0 == 0 {
            self.showAlertWithOk(title: "Info", message: "Please select mode of commute")
            return
        }
        param["ModeOfCommuteId"] = String(self.selectModeOfComm.0) as AnyObject
        
        let place = placeBtn.titleLabel?.text
        if place == selectPlaceString {
            self.showAlertWithOk(title: "Info", message: "Please select a place")
            return
        }
        param["Location"] = place as AnyObject
        param["Lat"] = String(latLong.0) as AnyObject
        param["Lng"] = String(latLong.1) as AnyObject
        
        param["HasOtp"] = 0 as AnyObject
        param["Otp"] = "" as AnyObject
        let otp = otpTxtFild.text?.trimmed()
        if (otp != nil && (otp!.count) > 0) {
            param["HasOtp"] = 1 as AnyObject
            param["Otp"] = otp as AnyObject
        }
        
        self.signUp()
        
    }
    
    @IBAction func loginAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}


extension RegisterViewController: GMSAutocompleteViewControllerDelegate {

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


extension RegisterViewController {
    
    private func signUp() {
        Utility.showLoaderWithTextMsg(text: "")
               
        NetworkManager.requestPOSTURL(Constants.APIServices.Signup, params: self.param, headers: nil, success: { (responseJSON) in
                   Utility.hideLoader()
                   let responseDictionary = responseJSON.dictionaryObject!
                   
                   if let msg = responseDictionary["Msg"] as? String {
                    if msg.containsIgnoringCase(find: "OTP GENERATED") {
                        self.showAlertWithOk(title: "Info", message: "Please check gaven number for OTP and press Register")
                    } else {
                        if msg.containsIgnoringCase(find: "SIGNUP SUCCESSULLY") {
                            let alert = UIAlertController(title: "Info", message: "Registration successfully. Please login.", preferredStyle: UIAlertController.Style.alert)
                            // add an action (button)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
                                self.backAction()
                            }))
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            self.showAlertWithOk(title: "Info", message: "There is some issue. Please try after some time")
                        }
                    }
                   } else {
                       self.showAlertWithOk(title: "Info", message: "There is some issue. Please try after some time")
                   }
               }) { (error) in
                   print(error)
                   Utility.hideLoader()
                   self.showAlertWithOk(title: "Error", message: "User not found")
               }
    }
    
    
    
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
    
}


class ModeOfComm {
    var IsActive: Bool = false
    var MOCDId: Int = 0
    var ModeOfCummute: String = "Select Mode Of Commute"
}
