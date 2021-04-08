//
//  ViewController.swift
//  Kumbhdwar
//
//  Created by Narender Kumar on 12/03/21.
//  Copyright © 2021 Narender Kumar. All rights reserved.
//

import UIKit
import Localize_Swift

class ViewController: UIViewController {
    
    @IBOutlet weak var headerTitle: UILabel! //Haridwar Kumbh 2021
    @IBOutlet weak var loginLbl: UILabel! //Login
    @IBOutlet weak var selectLoginTypeLbl: UILabel! //Please Select Login Type
    @IBOutlet weak var sendBtn: UIButton! //Resend Password
    @IBOutlet weak var sihninBtn: UIButton! //SIGN IN
    @IBOutlet weak var donHaveAccountLbl: UILabel! //Do Not Have an Account?
    @IBOutlet weak var signupBtn: UIButton! //Sign Up
    @IBOutlet weak var selectLangLbl: UILabel! //Please Select Language
    
    @IBOutlet weak var phoneBgView: CustomView!
    @IBOutlet weak var passwordBgView: CustomView!
    @IBOutlet weak var phoneTxtFild: UITextField! //Mobile No
    @IBOutlet weak var passwordTxtFild: UITextField! //Password
    @IBOutlet weak var visitorBtn: CheckBox!
    @IBOutlet weak var staffBtn: CheckBox!
    @IBOutlet weak var englishBtn: CheckBox!
    @IBOutlet weak var hindiBtn: CheckBox!
    private var userType = "VISITOR"
    private var iconClick = true
    private var hasPwd = 0

    //Lang 1
    let availableLanguages = Localize.availableLanguages()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.addLeftButtonOn(self.passwordTxtFild)
        self.passwordTxtFild.isSecureTextEntry = true
        
        self.phoneBgView.backgroundColor = UIColor.white
        self.passwordBgView.backgroundColor = UIColor.white
        
        self.visitorBtn.isChecked = true
        self.englishBtn.isChecked = true
        
        self.setTextOnView()
        UserDefaults.standard.setValue("es", forKey: "Lang")
        
        for language in availableLanguages {
            print(language)
        }
        
        
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
    
    private func setTextOnView() {
        self.visitorBtn.setTitle("Visitor".localized(), for: .normal)
        self.staffBtn.setTitle("Staff".localized(), for: .normal)
        
        self.headerTitle.text = "Haridwar Kumbh 2021".localized()
        self.loginLbl.text = "Login".localized()
        self.selectLoginTypeLbl.text = "Please Select Login Type".localized()
        self.donHaveAccountLbl.text = "Do not have an account?".localized()
        self.sendBtn.setTitle("Resend Password".localized(), for: .normal)
        self.sihninBtn.setTitle("Sign In".localized(), for: .normal)
        self.signupBtn.setTitle("Sign Up".localized(), for: .normal)
        self.phoneTxtFild.placeholder = "Mobile No".localized()
        self.passwordTxtFild.placeholder = "Password".localized()
        self.selectLangLbl.text = "Please Select Language".localized()
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
    
    @IBAction func englishAction(_ sender: CheckBox) {
        self.hindiBtn.isChecked = false
        UserDefaults.standard.setValue("es", forKey: "Lang")
        //Lang 2
        Localize.setCurrentLanguage("en")
        self.setTextOnView()
    }
    
    @IBAction func hindiAction(_ sender: CheckBox) {
        self.englishBtn.isChecked = false
        UserDefaults.standard.setValue("hi", forKey: "Lang")
        //Lang 2
        Localize.setCurrentLanguage("hi")
        self.setTextOnView()
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
                } else if (msg.containsIgnoringCase(find: "SUCCESSULLY") || msg.containsIgnoringCase(find: "SUCCESSFULLY")) {
                    UserManager.shared.activeUser = User(object: responseDictionary)
                    print(UserManager.shared.activeUser.CNO)
                    print(UserManager.shared.isUserLoggedIn())
                    UserManager.shared.saveActiveUser()
                    if (UserManager.shared.activeUser.RoleId == "6") {
                        guard let staffvc = UIStoryboard(name: Constants.StroyboardFiles.staff, bundle: nil).instantiateViewController(withIdentifier: Constants.StoryboardIdentifiers.staffVC) as? StaffVC else { return }
                        self.navigationController?.pushViewController(staffvc, animated: true)                    } else {
                            guard let parkingVC = UIStoryboard(name: Constants.StroyboardFiles.dashboard, bundle: nil).instantiateViewController(withIdentifier: Constants.StoryboardIdentifiers.dashboardVC) as? DashboardVC else { return }
                            self.navigationController?.pushViewController(parkingVC, animated: true)
                        }
                } else if (msg.containsIgnoringCase(find: "PASSWORD AND CONTACT NO DOES NOT MATCH")) {
                    self.showAlertWithOk(title: "Info", message: "Password and contact no does not match")
                }else {
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
