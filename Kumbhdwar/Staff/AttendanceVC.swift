//
//  AttendanceVC.swift
//  Kumbhdwar
//
//  Created by Peoplelink on 3/25/21.
//  Copyright © 2021 Narender Kumar. All rights reserved.
//

import UIKit

class AttendanceVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var dateOuterView: UIView!
    @IBOutlet weak var dateBtnBgView: UIView!
    @IBOutlet weak var myDatePicker: UIDatePicker!
 
    var detailsArray = [Any]()
    var valueChanged = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getAllAttendanceInfo(searchText: "")
    }
    
    private func setupUI() {
        detailsArray.removeAll()
        detailsArray = []
        tableView.estimatedRowHeight = 300.0
        tableView.rowHeight = UITableView.automaticDimension
        dateOuterView.borderWithColor(enable: true, withRadius: 10.0, width: 1.0, color: UIColor(named: "PrimaryColor") ?? .red)
        dateBtnBgView.borderWithColor(enable: true, withRadius: 10.0, width: 1.0, color: UIColor(named: "PrimaryColor") ?? .red)
        dateTextField.text = stringDate(date: Date())
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func dateValueChanged(_ sender: UIDatePicker) {
        valueChanged = true
    }
    
    @IBAction func dateEndEditing(_ sender: UIDatePicker) {
        if valueChanged {
            dateTextField.text = stringDate(date: sender.date)
            getAllAttendanceInfo(searchText: "")
            valueChanged = false
        }
    }
    
    @IBAction func punchInLocationTapped(_ sender: UIButton) {
        if let details = detailsArray[sender.tag] as? [String:Any], let punchInLat = details["InLat"] as? String, let punchInLong = details["InLng"] as? String {
            print(punchInLat, punchInLong)
        }
    }
    
    @IBAction func punchOutLocation(_ sender: UIButton) {
        if let details = detailsArray[sender.tag] as? [String:Any], let punchOutLat = details["OutLat"] as? String, let punchOutLong = details["OutLng"] as? String {
            print(punchOutLat, punchOutLong)
        }
    }
    
    @IBAction func markAttendance(_ sender: UIButton) {
        markAttendanceRequest(searchText: "")
    }
    
    func stringDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MMM-dd"
        return formatter.string(from: date)
    }
    
    func getAllAttendanceInfo(searchText: String?) {
        self.detailsArray.removeAll()
        self.detailsArray = []
        let headers = ["Authorization":"Basic cGF0bmE6cGF0bmEjMjAyMA==","Content-Type":"application/json"] as [String:String]
        Utility.showLoaderWithTextMsg(text: "Loading...")
        let parameters = [ "SearchText":"",
                           "PageNo":0,
                           "PageSize":10,
                           "LoginId":"7829801367",
                           "TDate": dateTextField.text ?? ""] as [String: AnyObject]
        let urlString = Constants.APIServices.getAttendance
        NetworkManager.requestPOSTURL(urlString, params: parameters, headers: headers) { (responseJson) in
            Utility.hideLoader()
            print(responseJson)
            if responseJson.count > 0, let arrayOfObjects = responseJson.arrayObject as? [[String:Any]] {
                self.detailsArray = arrayOfObjects
                self.tableView.reloadData()
            } else {
                self.detailsArray.removeAll()
                self.tableView.reloadData()
            }
        } failure: { (error) in
            print(error)
            Utility.hideLoader()
        }

    }
    func markAttendanceRequest(searchText: String?) {
        self.detailsArray.removeAll()
        self.detailsArray = []
        let headers = ["Authorization":"Basic cGF0bmE6cGF0bmEjMjAyMA==","Content-Type":"application/json"] as [String:String]
        guard let userContactNo = UserManager.shared.activeUser.Code, userContactNo.count > 0 else {
            successLabel(view: self.view, message: "Contact number is not available", completion: nil)
            return
        }
        Utility.showLoaderWithTextMsg(text: "Loading...")
        let parameters = [ "EmpId": userContactNo,
                           "TDate":"2021-03-28T16:47:42",
                           "TabId":"101",
                           "Lat":"76.898230",
                           "Lng":"25.879274"] as [String: AnyObject]
        let urlString = Constants.APIServices.pushBiometricData
        NetworkManager.requestPOSTURL(urlString, params: parameters, headers: headers) { (responseJson) in
            Utility.hideLoader()
            print(responseJson)
            if let json = responseJson.dictionaryObject, let message = json["Msg"] as? String {
                self.successLabel(view: self.view, message: message, completion: nil)
            }
        } failure: { (error) in
            print(error)
            Utility.hideLoader()
        }

    }
}

extension AttendanceVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailsArray.count > 0 ? detailsArray.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.StoryboardIdentifiers.attendanceCell) as? AttendanceCell else { return UITableViewCell() }
        if detailsArray.count > 0, let details = detailsArray[indexPath.row] as? [String:Any] {
            cell.setupCell(details: details)
            cell.punchInLocationButton.tag = indexPath.row
            cell.punchOutLocationButton.tag = indexPath.row
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
