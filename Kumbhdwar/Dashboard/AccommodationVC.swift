//
//  AccommodationVC.swift
//  Kumbhdwar
//
//  Created by Peoplelink on 3/21/21.
//  Copyright © 2021 Narender Kumar. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class AccommodationVC: UIViewController,CLLocationManagerDelegate {
    
    var detailsArray = [Any]()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextFieldOuterView: UIView!
    @IBOutlet weak var searchTextButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        detailsArray.removeAll()
        detailsArray = []
        tableView.estimatedRowHeight = 300.0
        tableView.rowHeight = UITableView.automaticDimension
        searchTextFieldOuterView.borderWithColor(enable: true, withRadius: 10.0, width: 1.0, color: UIColor(named: "PrimaryColor") ?? .red)
        searchTextButton.borderWithColor(enable: true, withRadius: 10.0, width: 1.0, color: UIColor(named: "PrimaryColor") ?? .red)
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            guard let currentLocation = locationManager.location else {
                return
            }
            self.currentLocation = currentLocation
            getAllAccommodationInfo(lat: "\(currentLocation.coordinate.latitude)", lon: "\(currentLocation.coordinate.longitude)", searchText: "")
        }
    }
    
    func getAllAccommodationInfo(lat: String, lon: String, searchText: String?) {
        self.detailsArray.removeAll()
        self.detailsArray = []
        let headers = ["Authorization":"Basic cGF0bmE6cGF0bmEjMjAyMA==","Content-Type":"application/json"] as [String:String]
        Utility.showLoaderWithTextMsg(text: "Loading...")
        let parameters = [ "SearchText":searchText, "PageNo":"0", "PageSize":"100", "Lat":lat, "Lng":lon] as [String: AnyObject]
        let urlString = Constants.APIServices.getAllAccommodation
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
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func searchTextButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        if let currentLocation = currentLocation {
            getAllAccommodationInfo(lat: "\(currentLocation.coordinate.latitude)", lon: "\(currentLocation.coordinate.longitude)", searchText: searchTextField.text)
        }
    }
    
    @IBAction func locationButtonTapped(_ sender: UIButton) {
        guard let details = detailsArray[sender.tag] as? [String : Any] else {return}
        print(sender.tag)
        if let lat = details["Lat"] as? String, let long = details["Lng"] as? String,let accommodationName = details["Accomodation_Name"] as? String, lat.count > 0, long.count > 0 {
            let sourceLocation = CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(long)!)
            print(lat,long,accommodationName, sourceLocation)
            if let name = details["Accomodation_Name"] as? String {
                self.showMap(sourceLocation, title: name)
            }
        }
        
    }
    
}

extension AccommodationVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailsArray.count > 0 ? detailsArray.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.StoryboardIdentifiers.accommodationCell) as? AccommodationCell else { return UITableViewCell() }
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


extension AccommodationVC {
    
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
