//
//  ParkingVC.swift
//  Kumbhdwar
//
//  Created by Peoplelink on 3/14/21.
//  Copyright © 2021 Narender Kumar. All rights reserved.
//


import UIKit
import DropDown
import MapKit
import CoreLocation
import Localize_Swift

class ParkingVC: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchTextFieldOuterView: UIView!
    @IBOutlet weak var searchTextButton: UIButton!
    @IBOutlet weak var searchViewHeightConstraint: NSLayoutConstraint!
    
    let dropDown = DropDown()
    var detailsArray = [[String:Any]]()
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var amenityTypeId = ""
    var dataSource:[String] = []
    var index = 0
    let amenityIds = ["2,4","6,8" ,"5,10,14,15,47", "6,11"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocalization()
        Utilities.setStatusBar()
        setupUI()
        setupDropDown()
        setupLocationManager()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func setupLocalization() {
        if let lang = UserDefaults.standard.object(forKey: "Lang") as? String {
            Localize.setCurrentLanguage(lang)
            self.setTextOnView()
            
        }
    }
    func setTextOnView() {
        searchTextField.placeholder = Constants.Placeholders.searchByName.localized()
//        searchButton.setTitle(Constants.Placeholders.search, for: .normal)
        searchTextButton.setTitle(Constants.Placeholders.search, for: .normal)
    }

    func setupUI(){
        searchView.borderWithColor(enable: true, withRadius: 10.0, width: 1.0, color: #colorLiteral(red: 0.9215686275, green: 0.231372549, blue: 0, alpha: 1))
        tableView.estimatedRowHeight = 150.0
        tableView.rowHeight = UITableView.automaticDimension
        titleLabel.text = title?.localized()
//        searchTextField.delegate = self
        switch title {
        case KumbhdwarList.allCases[3].text:
            searchView.isHidden = true
            self.searchViewHeightConstraint.constant = 0
            dataSource = ["Search Ghat Type","HK Ghat","Kumbh Ghat"]
        case KumbhdwarList.allCases[7].text:
            self.searchView.isHidden = true
            self.searchViewHeightConstraint.constant = 0
            dataSource = ["Search Parking Type", "Kumbh ISBT Route", "Kumbh Parking"]
        case KumbhdwarList.allCases[8].text:
            dataSource = [Constants.DropDowns.searchFacilityType.localized(), Constants.DropDowns.hospital.localized(), Constants.DropDowns.policeStation.localized(), Constants.DropDowns.vandingZone.localized(), Constants.DropDowns.toilet.localized(), Constants.DropDowns.lostAndFoundCenters.localized()]
            self.searchLabel.text = dataSource[0]
        case KumbhdwarList.allCases[9].text:
            dataSource = [Constants.DropDowns.searchTransportType.localized(), Constants.DropDowns.isbt.localized(), Constants.DropDowns.railwayStation.localized()]
            self.searchLabel.text = dataSource[0]

        default: break
        }
        
    }
    
    func setupDropDown() {
        dropDown.anchorView = self.searchButton // UIView or UIBarButtonItem
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = dataSource
        dropDown.width = searchButton.frame.width - 80
        dropDown.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        DropDown.appearance().textColor = #colorLiteral(red: 0.9215686275, green: 0.231372549, blue: 0, alpha: 1)
        DropDown.appearance().backgroundColor = UIColor.white
        searchTextFieldOuterView.borderWithColor(enable: true, withRadius: 10.0, width: 1.0, color: UIColor(named: "PrimaryColor") ?? .red)
        searchTextButton.borderWithColor(enable: true, withRadius: 10.0, width: 1.0, color: UIColor(named: "PrimaryColor") ?? .red)

    }
    func setupLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways) {
            determineCurrentLocation()
        }
    }
    func determineCurrentLocation() {

//        guard let currentLocation = locManager.location else {
//            return
////        }
//        print(currentLocation.coordinate.latitude)
//        print(currentLocation.coordinate.longitude)
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            guard let currentLocation = locationManager.location else {
                return
            }
            self.currentLocation = currentLocation
            getParkingDetails(location: currentLocation, amenityId: amenityTypeId)
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
    }
    
    @IBAction func searchTextButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        if let currentLocation = currentLocation {
            getParkingDetails(location: currentLocation, amenityId: amenityTypeId, searchText: searchTextField.text ?? "")
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        dropDown.show()
        // Action triggered on selection
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            self.searchLabel.text = item.localized()
            guard let currentLocation = self.currentLocation else { self.dropDown.hide(); return }
            if title == KumbhdwarList.allCases[8].text {
                switch index {
                case 0: getParkingDetails(location: currentLocation, amenityId: amenityTypeId);break
                case 1: getParkingDetails(location: currentLocation, amenityId: "5");break
                case 2: getParkingDetails(location: currentLocation, amenityId: "10");break
                case 3: getParkingDetails(location: currentLocation, amenityId: "14");break
                case 4: getParkingDetails(location: currentLocation, amenityId: "15");break
                case 5: getParkingDetails(location: currentLocation, amenityId: "47");break
                default: break
                }
            } else {
                let arr = amenityTypeId.components(separatedBy: ",")
                switch index {
                case 0: getParkingDetails(location: currentLocation, amenityId: amenityTypeId);break
                case 1: getParkingDetails(location: currentLocation, amenityId: arr[0]);break
                case 2: getParkingDetails(location: currentLocation, amenityId: arr[1]);break
                default: break
                }
            }
            
            self.dropDown.hide()
        }
    }
    
    @IBAction func locationButtonTapped(_ sender: UIButton) {
        let details = detailsArray[sender.tag]
        print(sender.tag)
        if let lat = details["Lat1"] as? String, let long = details["Lng1"] as? String, let desc = details["Description"] as? String, lat.count > 0, long.count > 0 {
            let cllocationcordinator = CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(long)!)
            showPrakingMap(cllocationcordinator, title: desc)
        }
    }
}

extension ParkingVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailsArray.count > 0 ? detailsArray.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.StoryboardIdentifiers.parkingCell) as? ParkingCell else { return UITableViewCell() }
        if detailsArray.count > 0 {
            let details = detailsArray[indexPath.row]
            cell.setupCell(details: details)
            cell.locationButton.tag = indexPath.row
            cell.descriptionWidthConstraint.constant = Localize.currentLanguage() == "hi" ? 60 : 100
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        showPrakingMap()
    }
}

extension ParkingVC {
    private func getParkingDetails(location: CLLocation, amenityId: String, searchText: String = "") {
        let headers = ["Authorization":"Basic cGF0bmE6cGF0bmEjMjAyMA==","Content-Type":"application/json"] as [String:String]
        let latitude = "\(location.coordinate.latitude)"
        let longitude = "\(location.coordinate.longitude)"
        if latitude.count > 0, longitude.count > 0 {
            Utility.showLoaderWithTextMsg(text: "Loading...")
            let parameters = ["SearchText":searchText,
                              "PageNo":"0",
                              "PageSize":"100",
                              "AmenityTypeId": amenityId,
                              "Lat":latitude,
                              "Lng":longitude] as [String: AnyObject]
            NetworkManager.requestPOSTURL(Constants.APIServices.DataById, params: parameters, headers: headers) { (responseJSON) in
                Utility.hideLoader()
                self.detailsArray.removeAll()
                self.detailsArray = [[:]]
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
        
    }
}

extension ParkingVC {
    
    private func showPrakingMap(_ destinationCoordinate: CLLocationCoordinate2D, title:String) {
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
    
    private func dummmyData() -> [UserLocation] {
        var userLocation: [UserLocation] = []
        userLocation.append(UserLocation(latLong: CLLocationCoordinate2D(latitude: 25.4358, longitude: 81.8463), name: "ABCDEFG 1"))
        userLocation.append(UserLocation(latLong: CLLocationCoordinate2D(latitude: 25.5358, longitude: 81.6463), name: "ABCDEFG 2"))
        userLocation.append(UserLocation(latLong: CLLocationCoordinate2D(latitude: 25.6358, longitude: 81.7463), name: "ABCDEFG 3"))
        userLocation.append(UserLocation(latLong: CLLocationCoordinate2D(latitude: 25.6358, longitude: 81.9463), name: "ABCDEFG 4"))
        return userLocation
    }
    
    private func showAddTracker() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        var mapTrackerVC = MapTrackerViewController()
        if #available(iOS 13.0, *) {
            mapTrackerVC = (sb.instantiateViewController(identifier: "MapTrackerViewController") as? MapTrackerViewController)!
        } else {
            mapTrackerVC = sb.instantiateViewController(withIdentifier: "MapTrackerViewController") as! MapTrackerViewController
        }
        mapTrackerVC.usersLocationsWithName = self.dummmyData()
        self.navigationController?.pushViewController(mapTrackerVC, animated: true)
    }
    
    private func showNearME() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        var mapTrackerVC = NearMeViewController()
        if #available(iOS 13.0, *) {
            mapTrackerVC = (sb.instantiateViewController(identifier: "NearMeViewController") as? NearMeViewController)!
        } else {
            mapTrackerVC = sb.instantiateViewController(withIdentifier: "NearMeViewController") as! NearMeViewController
        }
        self.navigationController?.pushViewController(mapTrackerVC, animated: true)
    }
    
    
}
