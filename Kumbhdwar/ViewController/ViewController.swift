//
//  ViewController.swift
//  Kumbhdwar
//
//  Created by Narender Kumar on 12/03/21.
//  Copyright © 2021 Narender Kumar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var phoneBgView: CustomView!
    @IBOutlet weak var passwordBgView: CustomView!
    @IBOutlet weak var phoneTxtFild: UITextField!
    @IBOutlet weak var passwordTxtFild: UITextField!
    @IBOutlet weak var visitorBtn: CheckBox!
    @IBOutlet weak var staffBtn: CheckBox!
    private var userType = "VISITOR"
    private var iconClick = true
    private var hasPwd = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.addLeftButtonOn(self.passwordTxtFild)
        self.passwordTxtFild.isSecureTextEntry = true
        
        self.phoneBgView.backgroundColor = UIColor.white
        self.passwordBgView.backgroundColor = UIColor.white
        
        self.visitorBtn.isChecked = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
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
    
    @IBAction func showPassword(_ sender: Any) {
        if(iconClick == true) {
            passwordTxtFild.isSecureTextEntry = false
        } else {
            passwordTxtFild.isSecureTextEntry = true
        }

        iconClick = !iconClick
    }

    @IBAction func signInButtonTapped(_ sender: UIButton) {
        
        let phone = phoneTxtFild.text?.trimmed()
        if !(phone != nil && (phone?.length)! > 0) {
            self.showAlertWithOk(title: "Info", message: "Please enter phone number")
            return
        }

        hasPwd = 0
        let password = passwordTxtFild.text?.trimmed()
        if (password != nil && (password?.length)! > 0) {
            hasPwd = 1
        }

        self.login(phone!, password: password!)
    }
    
    @IBAction func visitorAction(_ sender: CheckBox) {
        self.staffBtn.isChecked = false
        self.userType = "VISITOR"
    }
    
    @IBAction func staffAction(_ sender: CheckBox) {
        self.visitorBtn.isChecked = false
        self.userType = "STAFF"
    }
    
}


extension ViewController {
    
    private func login(_ phone: String, password: String) {
        /*
         "ContactNo":"7849801367",
         "Pwd":"raj@123",
         "HasPwd":1,
         "LoginType":"VISITOR"
         */
        
        Utility.showLoaderWithTextMsg(text: "Loading...")
        
        let parameters = ["ContactNo":phone, "Pwd":password, "HasPwd":hasPwd, "LoginType":userType ] as? [String: AnyObject]
        
        NetworkManager.requestPOSTURL(Constants.APIServices.Login, params: parameters, headers: nil, success: { (responseJSON) in
            Utility.hideLoader()
            let responseDictionary = responseJSON.dictionaryObject!
            
            if let msg = responseDictionary["Msg"] as? String {
                if msg.containsIgnoringCase(find:"PASSWORD SENT") {
                    self.showAlertWithOk(title: "Info", message: "Password sent througn OTP successfully")
                } else if msg.containsIgnoringCase(find: "SUCCESSULLY") {
                    UserManager.shared.activeUser = User(object: responseDictionary)
                    print(UserManager.shared.activeUser.CNO)
                    print(UserManager.shared.isUserLoggedIn())
                    UserManager.shared.saveActiveUser()
                    
                    guard let parkingVC = UIStoryboard(name: Constants.StroyboardFiles.dashboard, bundle: nil).instantiateViewController(withIdentifier: Constants.StoryboardIdentifiers.dashboardVC) as? DashboardVC else { return }
                    self.navigationController?.pushViewController(parkingVC, animated: true)
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
