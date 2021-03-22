//
//  JourneyPlannerVC.swift
//  Kumbhdwar
//
//  Created by Peoplelink on 3/19/21.
//  Copyright © 2021 Narender Kumar. All rights reserved.
//

import UIKit

class JourneyPlannerVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addJourneyButton: UIButton!
    var detailsArray = [Any]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        getAllPlannerList()
    }

    func setupUI() {
        detailsArray.removeAll()
        detailsArray = []
        tableView.estimatedRowHeight = 300.0
        tableView.rowHeight = UITableView.automaticDimension
        self.addJourneyButton.borderWithColor(enable: true, withRadius: 10.0, width: 1.0, color: UIColor(named: "PrimaryColor") ?? .red)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    func getAllPlannerList() {
        self.detailsArray.removeAll()
        self.detailsArray = []
        let headers = ["Authorization":"Basic cGF0bmE6cGF0bmEjMjAyMA==","Content-Type":"application/json"] as [String:String]
        Utility.showLoaderWithTextMsg(text: "Loading...")
        var
            urlString = Constants.APIServices.getAllPlannerList
        let visitorId = "7849801367"
        urlString += visitorId
        NetworkManager.requestGETURL(urlString, headers: headers) { (responseJSON) in
            Utility.hideLoader()
            print(responseJSON)
            if responseJSON.count > 0, let arrayOfObjects = responseJSON.arrayObject as? [[String:Any]] {
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
    
    @IBAction func locationButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func addNewJourneyButtonTapped(_ sender: UIButton) {
        
    }
    
}

extension JourneyPlannerVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailsArray.count > 0 ? detailsArray.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.StoryboardIdentifiers.journeyCell) as? JourneyCell else { return UITableViewCell() }
        if detailsArray.count > 0, let details = detailsArray[indexPath.row] as? [String:Any] {
            cell.setupCell(details: details)
            cell.locationButton.tag = indexPath.row
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}
