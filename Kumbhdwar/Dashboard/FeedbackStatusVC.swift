//
//  FeedbackStatusVC.swift
//  Kumbhdwar
//
//  Created by Peoplelink on 3/18/21.
//  Copyright © 2021 Narender Kumar. All rights reserved.
//

import UIKit
import CoreLocation

class FeedbackStatusVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var raiseFeedBackButton: UIButton!

    var detailsArray = [Any]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        getAllCategories()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    func setupUI() {
        detailsArray.removeAll()
        detailsArray = []
        tableView.estimatedRowHeight = 300.0
        tableView.rowHeight = UITableView.automaticDimension
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func locationButtonTapped(_ sender: UIButton) {
        //sender.tag
        guard let details = detailsArray[sender.tag] as? [String : Any] else {return}
        print(sender.tag)
        if let lat = details["Lat"] as? String, let long = details["Lng"] as? String, let name = details["Complaint"] as? String, lat.count > 0, long.count > 0 {
            let cllocationcordinator = CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(long)!)
            print(lat,long,name,cllocationcordinator)
        }
    }
    
    @IBAction func imageButtonTapped(_ sender: UIButton) {
    
    }
    @IBAction func raiseFeedBackTapped(_ sender: UIButton) {
        guard let raiseFeedback = UIStoryboard(name: Constants.StroyboardFiles.dashboard, bundle: nil).instantiateViewController(withIdentifier: Constants.StoryboardIdentifiers.raiseFeedbackVC) as? RaiseFeedbackVC else { return }
        self.navigationController?.pushViewController(raiseFeedback, animated: true)
    }

    
    func getAllCategories() {
        self.detailsArray.removeAll()
        self.detailsArray = []
        let headers = ["Authorization":"Basic cGF0bmE6cGF0bmEjMjAyMA==","Content-Type":"application/json"] as [String:String]
        Utility.showLoaderWithTextMsg(text: "Loading...")
        let parameters = ["SearchText":"","PageNo":"0", "PageSize":"10", "ContactNo":"9990802194"] as [String: AnyObject]
        let urlString = Constants.APIServices.getAllComplaint
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

extension FeedbackStatusVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailsArray.count > 0 ? detailsArray.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.StoryboardIdentifiers.feedbackStatusCell) as? FeedbackStatusCell else { return UITableViewCell() }
        if detailsArray.count > 0, let details = detailsArray[indexPath.row] as? [String:Any] {
            cell.setupCell(details: details)
            cell.locationButton.tag = indexPath.row
            cell.imageButton.tag = indexPath.row
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
