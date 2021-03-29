//
//  ApplyLeaveVC.swift
//  Kumbhdwar
//
//  Created by Peoplelink on 3/29/21.
//  Copyright © 2021 Narender Kumar. All rights reserved.
//

import UIKit

protocol ApplyDelegate: class {
    func sendMessage(msg: String?)
}

class ApplyLeaveVC: UIViewController {

    @IBOutlet weak var fromDateOuterView: UIView!
    @IBOutlet weak var fromDateButtonBgView: UIView!
    @IBOutlet weak var fromDatePicker: UIDatePicker!
    @IBOutlet weak var fromDateTextField: UITextField!
    @IBOutlet weak var toDateOuterView: UIView!
    @IBOutlet weak var toDateTextField: UITextField!
    @IBOutlet weak var toDateButtonBgView: UIView!
    @IBOutlet weak var toDatePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    var isFromDateValueChanged = false
    var isToDateValueChanged = false
    weak var delegate: ApplyDelegate?
    var placeholder = " Description :"

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    private func setupUI() {
        self.fromDateOuterView.borderWithColor(enable: true, withRadius: 10.0, width: 1.0, color: UIColor(named: "PrimaryColor") ?? .red)
        self.toDateOuterView.borderWithColor(enable: true, withRadius: 10.0, width: 1.0, color: UIColor(named: "PrimaryColor") ?? .red)
        self.fromDateButtonBgView.borderWithColor(enable: true, withRadius: 10.0, width: 1.0, color: UIColor(named: "PrimaryColor") ?? .red)
        self.toDateButtonBgView.borderWithColor(enable: true, withRadius: 10.0, width: 1.0, color: UIColor(named: "PrimaryColor") ?? .red)
        self.descriptionTextView.borderWithColor(enable: true, withRadius: 10.0, width: 1.0, color: UIColor(named: "PrimaryColor") ?? .red)
        self.submitButton.borderWithColor(enable: true, withRadius: 10.0, width: 1.0, color: UIColor(named: "PrimaryColor") ?? .red)
        self.fromDateTextField.text = stringDate(date: Date())
        self.toDateTextField.text = stringDate(date: Date())
        self.descriptionTextView.textColor = UIColor(named: "PrimaryColor") ?? .red
        self.descriptionTextView.text = placeholder
        self.descriptionTextView.delegate = self
        self.descriptionTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func stringDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        return formatter.string(from: date)
    }

    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func fromDateValueChanged(_ sender: UIDatePicker) {
        isFromDateValueChanged = true
    }
    
    @IBAction func toDateValueChanged(_ sender: UIDatePicker) {
        isToDateValueChanged = true
    }
    
    @IBAction func fromDateEndEditing(_ sender: UIDatePicker) {
        if isFromDateValueChanged {
            self.fromDateTextField.text = stringDate(date: sender.date)
            self.toDateTextField.text = ""
            isFromDateValueChanged = false
        }
    }
    
    @IBAction func todateEndEditing(_ sender: UIDatePicker) {
        if isToDateValueChanged {
            self.toDateTextField.text = stringDate(date: sender.date)
            isToDateValueChanged = false
        }
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        applyLeavePostRequest()
    }
    
    func applyLeavePostRequest() {
        if descriptionTextView.text == placeholder {
            self.successLabel(view: self.view, message: "Please enter remark", completion: nil); return
        }
        guard let userContactNo = UserManager.shared.activeUser.Code, userContactNo.count > 0 else {
            successLabel(view: self.view, message: "Contact number is not available", completion: nil)
            return
        }
        let headers = ["Authorization":"Basic cGF0bmE6cGF0bmEjMjAyMA==","Content-Type":"application/json"] as [String:String]
        Utility.showLoaderWithTextMsg(text: "Loading...")
        let parameters = [ "LeaveRequestId":"0",
                           "LoginId": userContactNo,
                           "FromDate": fromDateTextField.text ?? "",
                           "ToDate": toDateTextField.text ?? "",
                           "Remark": descriptionTextView.text ?? ""] as [String: AnyObject]
        let urlString = Constants.APIServices.requestLeave
        NetworkManager.requestPOSTURL(urlString, params: parameters, headers: headers) { (responseJson) in
            Utility.hideLoader()
            print(responseJson)
            if let json = responseJson.dictionaryObject, let message = json["Msg"] as? String {
                self.delegate?.sendMessage(msg: message)
                self.navigationController?.popViewController(animated: true)
            }
        } failure: { (error) in
            print(error)
            Utility.hideLoader()
        }

    }

}

extension ApplyLeaveVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholder {
            textView.text = nil
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Description"
        }

    }
    func successLabel(view: UIView, message: String, completion: ((Bool) -> Void)?) {
        
        let backgroundView = UIView(frame: CGRect(x: 50, y: view.frame.size.height - 150, width: view.frame.size.width - 80, height: 40))
        
        backgroundView.backgroundColor = #colorLiteral(red: 0.2784313725, green: 0.2784313725, blue: 0.2784313725, alpha: 1)
        backgroundView.round(enable: true, withRadius: nil)
        
        let label = UILabel(frame: CGRect(x: backgroundView.frame.origin.x + 5, y: backgroundView.frame.origin.y, width: backgroundView.frame.width - 10, height: 40))
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
