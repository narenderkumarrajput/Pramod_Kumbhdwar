//
//  AddTrackerPersonVC.swift
//  Kumbhdwar
//
//  Created by Narender Kumar on 16/03/21.
//  Copyright © 2021 Narender Kumar. All rights reserved.
//

import UIKit
import DropDown

class AddTrackerPersonVC: UIViewController {
    
    @IBOutlet weak var phoneTxtFild: UITextField!
    @IBOutlet weak var nameTxtFild: UITextField!
    @IBOutlet weak var familyBtn: UIButton!
    @IBOutlet weak var otpTxtFild: UITextField!
    let dropDown = DropDown()
    var selectGroup = "FAMILY"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.navigationItem.title = "REGISTER"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = AppStyleGuide.NewUI.Colors.appBg
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "ic_arrow_back_white_24dp"), for: .normal)
        button.addTarget(self, action:#selector(AddTrackerPersonVC.backAction), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItems = [barButton]
        
        dropDown.anchorView = self.familyBtn // UIView or UIBarButtonItem
        dropDown.dataSource = ["Family", "Friend"]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func familyAction(_ sender: Any) {
        dropDown.show()
        // Action triggered on selection
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            selectGroup = "FRIEND"
            self.familyBtn.setTitle("Friend", for: .normal)
            if item == "Family" {
                selectGroup = "FAMILY"
                self.familyBtn.setTitle("Family", for: .normal)
            }
            self.self.dropDown.hide()
        }
    }
    
    
    @IBAction func registerAction(_ sender: Any) {
        let phone = phoneTxtFild.text?.trimmed()
        if !(phone != nil && (phone?.length)! > 0) {
            self.showAlertWithOk(title: "Info", message: "Please enter phone number")
            return
        }
        
        let name = nameTxtFild.text?.trimmed()
        if !(name != nil && (name!.count) > 0) {
            self.showAlertWithOk(title: "Info", message: "Please enter your name")
            return
        }
        
        let otp = otpTxtFild.text?.trimmed()
        if !(otp != nil && (otp!.count) > 0) {
            self.showAlertWithOk(title: "Info", message: "Please enter otp")
            return
        }
        
        self.addUserInTrackerGroup()
        
    }
    
    @IBAction func otpAction(_ sender: Any) {
        let phone = phoneTxtFild.text?.trimmed()
        if !(phone != nil && (phone?.length)! > 0) {
            self.showAlertWithOk(title: "Info", message: "Please enter phone number")
            return
        }
        
        let name = nameTxtFild.text?.trimmed()
        if !(name != nil && (name!.count) > 0) {
            self.showAlertWithOk(title: "Info", message: "Please enter your name")
            return
        }
        
        self.getOtp()
    }

    
    @IBAction func shoeMapAction(_ sender: Any) {
        
    }
}


extension AddTrackerPersonVC {
    
    private func getOtp() {
        /*
         "ContactNo":"7849801367",
             "GroupType":"FAMILY",
             "CreatedBy":"9599913932",
             "Name":"RAJROOP"
         */
        
        let contactNo = self.phoneTxtFild.text
        
        Utility.showLoaderWithTextMsg(text: "Loading...")
        let user = UserManager.shared.activeUser
        let parameters = ["ContactNo": contactNo! , "GroupType": selectGroup, "CreatedBy":  user?.UHouseId ?? "" as Any?, "Name": nameTxtFild.text! ] as [String: AnyObject]
        
        NetworkManager.requestPOSTURL(Constants.APIServices.GetOTPforAddUser, params: parameters, headers: nil, success: { (responseJSON) in
            Utility.hideLoader()
            let responseDictionary = responseJSON.dictionaryObject!
            
            if let msg = responseDictionary["Msg"] as? String {
                if msg.containsIgnoringCase(find: "OTP HAS BEEN SENT SUCCESSFULLY") {
                    self.showAlertWithOk(title: "Info", message: "OTP Sent. Please fill it in OTP field.")
                } else {
                    self.showAlertWithOk(title: "Info", message: "There is some issue. Please try after some time")
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
    
    private func addUserInTrackerGroup() {
        /*
         "ContactNo":"7849801367",
             "GroupType":"FAMILY",
             "CreatedBy":"9599913932",
             "OTP":"606217"
         */
        
        let contactNo = self.phoneTxtFild.text
        let otp = self.otpTxtFild.text
        
        Utility.showLoaderWithTextMsg(text: "Loading...")
        let user = UserManager.shared.activeUser
        let parameters = ["ContactNo": contactNo! , "GroupType": selectGroup, "CreatedBy":  user?.UHouseId ?? "" as Any?, "Name": nameTxtFild.text!, "OTP": otp ] as [String: AnyObject]
        
        NetworkManager.requestPOSTURL(Constants.APIServices.AddUserToTrackGroup, params: parameters, headers: nil, success: { (responseJSON) in
            Utility.hideLoader()
            let responseDictionary = responseJSON.dictionaryObject!
            
            if let msg = responseDictionary["Result"] as? String {
                if msg == "1" {
                    self.showAlertWithOk(title: "Info", message: "Person added in group")
                } else {
                    self.showAlertWithOk(title: "Info", message: "There is some issue. Please try after some time")
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
    
}
