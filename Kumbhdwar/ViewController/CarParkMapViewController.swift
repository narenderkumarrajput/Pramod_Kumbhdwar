//
//  CarParkMapViewController.swift
//  Kumbhdwar
//
//  Created by Narender Kumar on 18/03/21.
//  Copyright © 2021 Narender Kumar. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import Localize_Swift

class CarParkMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var parkBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    private var locationManager = CLLocationManager()
    private var param:[String: AnyObject] = [:]
    private var carPark: CarPark? = nil
    var bounds = GMSCoordinateBounds()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Find My Car"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = AppStyleGuide.NewUI.Colors.appBg
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "ic_arrow_back_white_24dp"), for: .normal)
        button.addTarget(self, action:#selector(CarParkMapViewController.backAction), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItems = [barButton]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showUserLocationOnMap()
        
        if let lang = UserDefaults.standard.object(forKey: "Lang") as? String {
            Localize.setCurrentLanguage(lang)
            self.setTextOnView()
        }
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setTextOnView() {
        self.parkBtn.setTitle("Car Park".localized(), for: .normal)
        self.searchBtn.setTitle("Car Search".localized(), for: .normal)
    }
    
    private func showUserLocationOnMap() {
        let UHouseId = UserManager.shared.activeUser
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        
        if CLLocationManager.locationServicesEnabled() {
            print("yes")
        }
        else {
            print("no")
        }
    }
    
    private func showOtherUsersLocationOnMap(_ carLocation: [CarPark]) {
        
        for user in carLocation {
            let latLong: CLLocationCoordinate2D =  CLLocationCoordinate2D(latitude: Double(user.carLat) ?? 0.0, longitude: Double(user.carLng) ?? 0.0)
            let marker = GMSMarker(position: latLong)
            marker.icon = GMSMarker.markerImage(with: UIColor.red)
            marker.title = user.vehicleNo
            if user.vehicleNo == "0" {
                marker.title = "Your car"
            } else if user.vehicleNo == "" {
                marker.title = "Your car"
            }
            
            marker.map = mapView
            mapView.selectedMarker = marker
            
            bounds = bounds.includingCoordinate(latLong)
        }
        
        let seconds = 0.5
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [self] in
            let update = GMSCameraUpdate.fit(bounds, withPadding: 30)
            mapView.animate(with: update)
        }
            
    }
    
    @IBAction func parkAction(_ sender: UIButton) {
        self.getCarPark()
    }
    
    @IBAction func searchAction(_ sender: UIButton) {
        self.getMyCarLocation()
    }

}

extension CarParkMapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.startUpdatingLocation()

            case .denied:
                print("Location permission denied")
                self.showAlertWithOk(title: "Info", message: "Please go to Settings and turn on Location Service for this app.")

            case .restricted:
                print("Location permission restricted")
                self.showAlertWithOk(title: "Info", message: "Please go to Settings and turn on Location Service for this app.")

            case .notDetermined:
                print("Location permission notDetermined")
                self.showAlertWithOk(title: "Info", message: "Please go to Settings and turn on Location Service for this app.")

            @unknown default: break
                //fatalError()
            }
        }
    
    //Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)
        self.mapView?.animate(to: camera)
        //self.locationManager.stopUpdatingLocation()
        
        let marker = GMSMarker(position: location!.coordinate)
        marker.icon = GMSMarker.markerImage(with: UIColor.blue)
        marker.title = "Current Location"
        marker.map = mapView
        mapView.selectedMarker = marker
        
        let UHouseId = UserManager.shared.activeUser.UHouseId
        param["VisitorId"] = UHouseId as AnyObject?
        param["VehicleNo"] = "0" as AnyObject
        param["Remark"] = "100" as AnyObject
        param["CarLat"] = String(location!.coordinate.latitude) as AnyObject
        param["CarLng"] = String(location!.coordinate.longitude) as AnyObject
        
        bounds = bounds.includingCoordinate(location!.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("issue in get location")
    }
    
}


extension CarParkMapViewController {
    
    private func getMyCarLocation() {
        Utility.showLoaderWithTextMsg(text: "")
        let url = Constants.APIServices.getMyCarLocation + "\(UserManager.shared.activeUser.UHouseId ?? "")"
        NetworkManager.requestGETURL(url, headers: nil, params: [:], success: { (responseJSON) in
            Utility.hideLoader()
            let responseDictionary = responseJSON.dictionaryObject
            print(responseDictionary)
            if let _ = responseDictionary {
                let findMyCarID = responseDictionary?["FindMyCarId"] as? String
                let visitorID = responseDictionary?["VisitorId"] as? String
                let vehicleNo = responseDictionary?["VehicleNo"] as? String
                let remark = responseDictionary?["Remark"] as? String
                let carLat = responseDictionary?["CarLat"] as? String
                let carLng = responseDictionary?["CarLng"] as? String
                let datedOn = responseDictionary?["DatedOn"] as? String
                
                let carLoc = CarPark(findMyCarID: findMyCarID ?? "", visitorID: visitorID ?? "", vehicleNo: vehicleNo ?? "", remark: remark ?? "", carLat: carLat ?? "", carLng: carLng ?? "", datedOn: datedOn ?? "")
                
                self.showOtherUsersLocationOnMap([carLoc])
            } else {
                self.showAlertWithOk(title: "Info", message: "No car save location found")
            }
        }) { (error) in
            Utility.hideLoader()
            self.showAlertWithOk(title: "Error", message: error.localizedFailureReason)
        }
    }
    
    private func getCarPark() {
        /*
         "VisitorId":"9599913932",
             "VehicleNo":"abc",
             "Remark":"Parked my car",
             "CarLat":"0.00",
             "CarLng":"0.00"
         */
        
        Utility.showLoaderWithTextMsg(text: "")
        
        NetworkManager.requestPOSTURL(Constants.APIServices.saveCarLocation, params: self.param, headers: nil, success: { (responseJSON) in
            Utility.hideLoader()
            let responseDictionary = responseJSON.dictionaryObject!
            if let msg = responseDictionary["Result"] as? String {
                if msg == "1" || msg == "2"{
                    let alert = UIAlertController(title: "Info", message: "Your car park successfully for find my car location.", preferredStyle: UIAlertController.Style.alert)
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
                        self.backAction()
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                    
                } else {
                    self.showAlertWithOk(title: "Info", message: "There is some issue. Please try after some time")
                }
            } else {
                self.showAlertWithOk(title: "Info", message: "There is some issue. Please try after some time")
            }
        }) { (error) in
            print(error)
            Utility.hideLoader()
            self.showAlertWithOk(title: "Error", message: error.localizedDescription)
        }
        
    }
    
    private func carSearch() {
        
    }
    
}


class CarPark: Codable {
    let findMyCarID, visitorID, vehicleNo, remark: String
    let carLat, carLng, datedOn: String

    enum CodingKeys: String, CodingKey {
        case findMyCarID = "FindMyCarId"
        case visitorID = "VisitorId"
        case vehicleNo = "VehicleNo"
        case remark = "Remark"
        case carLat = "CarLat"
        case carLng = "CarLng"
        case datedOn = "DatedOn"
    }

    init(findMyCarID: String, visitorID: String, vehicleNo: String, remark: String, carLat: String, carLng: String, datedOn: String) {
        self.findMyCarID = findMyCarID
        self.visitorID = visitorID
        self.vehicleNo = vehicleNo
        self.remark = remark
        self.carLat = carLat
        self.carLng = carLng
        self.datedOn = datedOn
    }
}
