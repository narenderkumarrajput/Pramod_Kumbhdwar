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
    
 
    var detailsArray = [Any]()

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
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
                           "TDate":"2021-03-13"] as [String: AnyObject]
        let urlString = Constants.APIServices.getAttendance
        NetworkManager.requestPOSTURL(urlString, params: parameters, headers: headers) { (responseJson) in
            Utility.hideLoader()
            print(responseJson)
            if responseJson.count > 0, let arrayOfObjects = responseJson.arrayObject as? [[String:Any]] {
                self.detailsArray = arrayOfObjects
                self.tableView.reloadData()
            } else {
                self.detailsArray.removeAll()
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

}
