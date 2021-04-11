//
//  TrackerList.swift
//  Kumbhdwar
//
//  Created by Peoplelink on 3/20/21.
//  Copyright © 2021 Narender Kumar. All rights reserved.
//

import UIKit
import DropDown
import CoreLocation

class TrackerList: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addNewPersonButton: UIButton!
    @IBOutlet weak var onMapButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchOuterView: UIView!
    @IBOutlet weak var trackerListLangText: UILabel!
    
    var detailsArray = [Any]()
    let dropDown = DropDown()
    var isFamily = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupDropDown()
        isFamily = true
        getAllTrackerList(type: "FAMILY")
    }
    
    private func setupUI() {
        detailsArray.removeAll()
        detailsArray = []
        tableView.estimatedRowHeight = 300.0
        tableView.rowHeight = UITableView.automaticDimension
        addNewPersonButton.borderWithColor(enable: true, withRadius: 10.0, width: 1.0, color: UIColor(named: "PrimaryColor") ?? .red)
        onMapButton.borderWithColor(enable: true, withRadius: 10.0, width: 1.0, color: UIColor(named: "PrimaryColor") ?? .red)
        self.searchOuterView.borderWithColor(enable: true, withRadius: 10.0, width: 1.0, color: UIColor(named: "PrimaryColor") ?? .red)
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteTapped(_ sender: UIButton) {
        self.deleteTrack(sender.tag)
    }
    
    @IBAction func trackButtonTapped(_ sender: UIButton) {
        guard let details = detailsArray[sender.tag] as? [String : Any] else {return}
        print(sender.tag)
        if let lat = details["Lat"] as? String, let long = details["Lng"] as? String, let name = details["Name"] as? String, lat.count > 0, long.count > 0 {
            let cllocationcordinator = CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(long)!)
            print(lat,long,name,cllocationcordinator)
            self.showMap(cllocationcordinator, title: name)
        }
    }
    
    @IBAction func onMapButtonTapped(_ sender: UIButton) {
        if self.detailsArray.count > 0 {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            var nearMeVC = LocationsViewController()
            if #available(iOS 13.0, *) {
                nearMeVC = (sb.instantiateViewController(identifier: "LocationsViewController") as? LocationsViewController)!
            } else {
                nearMeVC = sb.instantiateViewController(withIdentifier: "LocationsViewController") as! LocationsViewController
            }
            let seconds = 0.5
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                nearMeVC.showMamberList(self.detailsArray)
            }
            self.navigationController?.pushViewController(nearMeVC, animated: true)
        }
    }
    
    @IBAction func addNewTapped(_ sender: UIButton) {
        guard let register = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddTrackerPersonVC") as? AddTrackerPersonVC else { return }
        self.navigationController?.pushViewController(register, animated: true)
    }
    
    @IBAction func searchButtonTaaped(_ sender: UIButton) {
    
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            self.searchButton.setTitle(item, for: .normal)
            switch index {
            case 0:
                getAllTrackerList(type:"FAMILY");
                isFamily = true
                break
            case 1:
                getAllTrackerList(type: "FRIEND");
                isFamily = false
                break
            default: break
            }
            self.dropDown.hide()
            
        }

    }
    
    func getAllTrackerList(type: String) {
        self.detailsArray.removeAll()
        self.detailsArray = []
        let headers = ["Authorization":"Basic cGF0bmE6cGF0bmEjMjAyMA==","Content-Type":"application/json"] as [String:String]
        Utility.showLoaderWithTextMsg(text: "Loading...")
        let parameters = ["SearchText":"",
                          "PageNo":"0",
                          "PageSize":"1000",
                          "LoginId": UserManager.shared.activeUser.CNO ?? "7989237387",
                          "GroupType":type] as [String: AnyObject]
        let urlString = Constants.APIServices.getalluserTrackInfo
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
    
    
    func deleteTrack(_ idx: Int) {
 
        let details = detailsArray[idx] as? [String : Any]
        let journeyId = details!["UserTrackPId"] as? Int
        
        let headers = ["Authorization":"Basic cGF0bmE6cGF0bmEjMjAyMA==","Content-Type":"application/json"] as [String:String]
        Utility.showLoaderWithTextMsg(text: "Loading...")
        var urlString = Constants.APIServices.deleteTracker
        urlString += String(journeyId ?? 0)
        NetworkManager.requestGETURL(urlString, headers: headers) { (responseJSON) in
            Utility.hideLoader()
            print(responseJSON)
            let seconds = 0.4
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                if self.isFamily {
                    self.getAllTrackerList(type: "FAMILY")
                } else {
                    self.getAllTrackerList(type: "FRIEND");
                }
                
            }
            
        } failure: { (error) in
            print(error)
            Utility.hideLoader()
        }
    }
    
    
    func setupDropDown() {
        dropDown.anchorView = self.searchOuterView // UIView or UIBarButtonItem
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = ["Family","Friend"]
        dropDown.width = searchOuterView.frame.width - 50
        dropDown.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        DropDown.appearance().textColor = UIColor(named: "PrimaryColor") ?? .red
        DropDown.appearance().backgroundColor = UIColor.white

    }
    
}


extension TrackerList: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailsArray.count > 0 ? detailsArray.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.StoryboardIdentifiers.trackerCell) as? TrackerCell else { return UITableViewCell() }
        if detailsArray.count > 0, let details = detailsArray[indexPath.row] as? [String:Any] {
            cell.setupCell(details: details)
            cell.trackerButton.tag = indexPath.row
            cell.deleteButton.tag = indexPath.row
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}




extension TrackerList {
    
    private func showMap(_ destinationCoordinate: CLLocationCoordinate2D, title:String) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        var mapVC = MapViewController()
        if #available(iOS 13.0, *) {
            mapVC = (sb.instantiateViewController(identifier: "MapViewController") as? MapViewController)!
        } else {
            mapVC = sb.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        }
        mapVC.latLong = destinationCoordinate
        mapVC.mapTitle = title
        
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
}
