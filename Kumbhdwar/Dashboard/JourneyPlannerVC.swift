//
//  JourneyPlannerVC.swift
//  Kumbhdwar
//
//  Created by Peoplelink on 3/19/21.
//  Copyright © 2021 Narender Kumar. All rights reserved.
//

import UIKit
import CoreLocation

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
        let visitorId = "7989237387"
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
        guard let details = detailsArray[sender.tag] as? [String : Any] else {return}
        print(sender.tag)
        var sourceLocation: CLLocationCoordinate2D?
        var destinationGhatLocation: CLLocationCoordinate2D?
        var parkingLocation: CLLocationCoordinate2D?

        if let lat = details["SourceLat"] as? String, let long = details["SourceLng"] as? String, lat.count > 0, long.count > 0 {
            sourceLocation = CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(long)!)
            print(lat,long,sourceLocation ?? 0.0)
        }
        if let lat = details["DestinationGhatLat"] as? String, let long = details["DestinationGhatLng"] as? String, lat.count > 0, long.count > 0 {
            destinationGhatLocation = CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(long)!)
            print(lat,long,destinationGhatLocation ?? 0.0)
        }
        if let lat = details["ParkingLat"] as? String, let long = details["ParkingLng"] as? String, lat.count > 0, long.count > 0 {
            parkingLocation = CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(long)!)
            print(lat,long,parkingLocation ?? 0)
        }
        
    }
    
    @IBAction func addNewJourneyButtonTapped(_ sender: UIButton) {
        guard let addJourneyVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddJourneyRegViewController") as? AddJourneyRegViewController else { return }
        self.navigationController?.pushViewController(addJourneyVC, animated: true)
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
