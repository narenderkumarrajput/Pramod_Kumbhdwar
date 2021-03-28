//
//  TaskVC.swift
//  Kumbhdwar
//
//  Created by Peoplelink on 3/27/21.
//  Copyright © 2021 Narender Kumar. All rights reserved.
//

import UIKit

class TaskVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fromDateTextField: UITextField!
    @IBOutlet weak var toDateTextField: UITextField!
    @IBOutlet weak var fromDateBtnBGView: UIView!
    @IBOutlet weak var toDateBtnBgView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var myDatePicker: UIDatePicker!
    @IBOutlet weak var fromDateOuterView: UIView!
    @IBOutlet weak var toDateOuterView: UIView!
    
    var detailsArray = [Any]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    private func setupUI() {
        detailsArray.removeAll()
        detailsArray = []
        tableView.estimatedRowHeight = 300.0
        tableView.rowHeight = UITableView.automaticDimension
        fromDateOuterView.borderWithColor(enable: true, withRadius: 10.0, width: 1.0, color: UIColor(named: "PrimaryColor") ?? .red)
        toDateOuterView.borderWithColor(enable: true, withRadius: 10.0, width: 1.0, color: UIColor(named: "PrimaryColor") ?? .red)
        fromDateBtnBGView.borderWithColor(enable: true, withRadius: 10.0, width: 1.0, color: UIColor(named: "PrimaryColor") ?? .red)
        toDateBtnBgView.borderWithColor(enable: true, withRadius: 10.0, width: 1.0, color: UIColor(named: "PrimaryColor") ?? .red)
        fromDateTextField.text = stringDate(date: Date())
        toDateTextField.text = stringDate(date: Date())
        toDateTextField.delegate = self
        getMyAssignedTask(searchText: "")


    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func fromDateTapped(_ sender: UIDatePicker) {
        fromDateTextField.text = stringDate(date: sender.date)
    }
    
    @IBAction func toDateTapped(_ sender: UIDatePicker) {
        toDateTextField.text = stringDate(date: sender.date)
        
    }
    @IBAction func fromDidEndTapped(_ sender: UIDatePicker) {
        toDateTextField.text = ""
    }
    
    @IBAction func didEndDatePicker(_ sender: UIDatePicker) {
        getMyAssignedTask(searchText: "")
    }
    
    func getMyAssignedTask(searchText: String) {
        self.detailsArray.removeAll()
        self.detailsArray = []
        let headers = ["Authorization":"Basic cGF0bmE6cGF0bmEjMjAyMA==","Content-Type":"application/json"] as [String:String]
        Utility.showLoaderWithTextMsg(text: "Loading...")
        let parameters = ["SearchText":"",
                          "PageNo":"0",
                          "PageSize":"10",
                          "LoginId":"9992841473",
                          "DateFrom": fromDateTextField.text ?? "",
                          "DateTo": toDateTextField.text ?? ""] as [String: AnyObject]
        let urlString = Constants.APIServices.getMyAssignedTask
        NetworkManager.requestPOSTURL(urlString, params: parameters, headers: headers) { (responseJson) in
            Utility.hideLoader()
            print(responseJson)
            if responseJson.count > 0, let arrayOfObjects = responseJson.arrayObject as? [[String:Any]] {
                self.detailsArray = arrayOfObjects
                self.tableView.reloadData()
            } else {
                self.successLabel(view: self.view, message: "No Data", completion: nil)
                self.detailsArray.removeAll()
                self.tableView.reloadData()
            }
        } failure: { (error) in
            print(error)
            Utility.hideLoader()
        }

    }
    
    func stringDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        return formatter.string(from: date)
    }
    
    @objc func fromDateDoneButtonPressed() {
        if let  datePicker = self.fromDateTextField.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            self.fromDateTextField.text = dateFormatter.string(from: datePicker.date)
        }
        self.fromDateTextField.resignFirstResponder()
    }
    
    @objc func toDateDoneButtonPressed() {
        if let  datePicker = self.toDateTextField.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            self.toDateTextField.text = dateFormatter.string(from: datePicker.date)
        }
        self.toDateTextField.resignFirstResponder()
    }
    
}
extension TaskVC: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailsArray.count > 0 ? detailsArray.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.StoryboardIdentifiers.taskCell) as? TaskCell else { return UITableViewCell() }
        if detailsArray.count > 0, let details = detailsArray[indexPath.row] as? [String:Any] {
            cell.setupCell(details: details)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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

extension UITextField {

    func addInputViewDatePicker(target: Any, selector: Selector) {
        
        let screenWidth = UIScreen.main.bounds.width
        
        //Add DatePicker as inputView
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 300))
        datePicker.datePickerMode = .date
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .inline
        } else {
            // Fallback on earlier versions
        }
        self.inputView = datePicker
        
        //Add Tool Bar as input AccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: false)
        
        self.inputAccessoryView = toolBar
    }
    
    @objc func cancelPressed() {
        self.resignFirstResponder()
    }
}
