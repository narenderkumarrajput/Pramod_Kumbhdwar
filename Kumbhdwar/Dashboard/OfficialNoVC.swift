//
//  OfficialNoVC.swift
//  Kumbhdwar
//
//  Created by Peoplelink on 3/28/21.
//  Copyright © 2021 Narender Kumar. All rights reserved.
//

import UIKit
import Localize_Swift

class OfficialNoVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoIcon: UIImageView!
    @IBOutlet weak var officialNoLangText: UILabel!
    
    var detailsArray = [Any]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocalization()
        logoIcon.borderWithColor(enable: true, withRadius: 22.5, width: 1.0, color: .gray
        )
        getAllOfficialNo()
    }
    private func setupLocalization() {
        if let lang = UserDefaults.standard.object(forKey: "Lang") as? String {
            Localize.setCurrentLanguage(lang)
            self.setTextOnView()
        }
    }
    
    func setTextOnView() {
        officialNoLangText.text = "Official No.".localized()
    }
    func getAllOfficialNo() {
        self.detailsArray.removeAll()
        self.detailsArray = []
        let headers = ["Authorization":"Basic cGF0bmE6cGF0bmEjMjAyMA==","Content-Type":"application/json"] as [String:String]
        Utility.showLoaderWithTextMsg(text: "Loading...")
        let urlString = Constants.APIServices.getAllOfficialNo
        NetworkManager.requestGETURL(urlString, headers: headers) { (responseJSON) in
            Utility.hideLoader()
            print(responseJSON)
            if responseJSON.count > 0, let arrayOfObjects = responseJSON.arrayObject as? [[String:Any]] {
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

    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func callButtonTapped(_ sender: UIButton) {
        if detailsArray.count > 0, let details = detailsArray[sender.tag] as? [String:Any],let number = details["PhoneNo"] as? String {
            dialNumber(number: number)
        }
    }
    func dialNumber(number : String) {

     if let url = URL(string: "tel://\(number)"),
       UIApplication.shared.canOpenURL(url) {
          if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:], completionHandler:nil)
           } else {
               UIApplication.shared.openURL(url)
           }
       } else {
        print("wrong")
       }
    }

}

extension OfficialNoVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailsArray.count > 0 ? detailsArray.count : 0
//        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.StoryboardIdentifiers.officialCell) as? OfficialCell else { return UITableViewCell() }
        if detailsArray.count > 0, let details = detailsArray[indexPath.row] as? [String:Any] {
            cell.setupCell(details: details)
            cell.callButton.tag = indexPath.row
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}
