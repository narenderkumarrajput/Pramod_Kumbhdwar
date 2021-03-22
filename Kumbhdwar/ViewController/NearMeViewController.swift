//
//  NearMeViewController.swift
//  Kumbhdwar
//
//  Created by Narender Kumar on 17/03/21.
//  Copyright © 2021 Narender Kumar. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class NearMeViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var hospitalBtn: CheckBox!
    @IBOutlet weak var policeBtn: CheckBox!
    @IBOutlet weak var vendingZoneBtn: CheckBox!
    @IBOutlet weak var toiletBtn: CheckBox!
    @IBOutlet weak var railwayStationBtn: CheckBox!
    private var locationManager = CLLocationManager()
    private var param:[String: AnyObject] = [:]
    private var place:[Place] = []
    private var isFirst = true

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "NEAR ME"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = AppStyleGuide.NewUI.Colors.appBg
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "ic_arrow_back_white_24dp"), for: .normal)
        button.addTarget(self, action:#selector(NearMeViewController.backAction), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItems = [barButton]
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showUserLocationOnMap()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func showUserLocationOnMap() {
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        
        if CLLocationManager.locationServicesEnabled() {
            print("yes")
        }
        else {
            print("no")
        }
    }
    
    @IBAction func placeBtnAction(_ sender: CheckBox) {
        let btns = [hospitalBtn, policeBtn, vendingZoneBtn, toiletBtn, railwayStationBtn ]
        btns.forEach { (btn) in
            if btn?.tag == sender.tag {
            } else {
                btn?.isChecked = false
            }
            
        }
        param["AmenityTypeId"] = String(sender.tag) as AnyObject
        self.showPlaces()
    }
    
    func addMarker() {
        self.showUserLocationOnMap()
        
        self.mapView.clear()
        var bounds = GMSCoordinateBounds()
        for temp in self.place {
            let latLong: CLLocationCoordinate2D =  CLLocationCoordinate2D(latitude: Double(temp.lat1)!, longitude: Double(temp.lng1)!)
            let marker = GMSMarker(position: latLong)
            marker.icon = GMSMarker.markerImage(with: UIColor.red)
            marker.title = temp.welcomeDescription
            marker.map = mapView
            bounds = bounds.includingCoordinate(latLong)
        }
        
        let seconds = 0.5
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [self] in
            let update = GMSCameraUpdate.fit(bounds, withPadding: 30)
            mapView.animate(with: update)
        }
    }
    

}


extension NearMeViewController: CLLocationManagerDelegate {
    
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
        if isFirst {
            let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)
            self.mapView?.animate(to: camera)
            isFirst = false
        }
        self.locationManager.stopUpdatingLocation()
        
        let marker = GMSMarker(position: location!.coordinate)
        marker.icon = GMSMarker.markerImage(with: UIColor.blue)
        marker.title = "ME"
        marker.map = mapView
        mapView.selectedMarker = marker
        
        param["SearchText"] = "" as AnyObject
        param["PageNo"] = "0" as AnyObject
        param["PageSize"] = "2000" as AnyObject
        param["Lat"] = String(location!.coordinate.latitude) as AnyObject
        param["Lng"] = String(location!.coordinate.longitude) as AnyObject
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("issue in get location")
    }
    
}

extension NearMeViewController {
    
    private func showPlaces() {
        
        /*
         "SearchText":"",
         "PageNo":"0",
         "PageSize":"100",
         "AmenityTypeId":"5",
         "Lat":"30.1135881988418",
         "Lng":"78.2953164893311"
         */
        
        Utility.showLoaderWithTextMsg(text: "")
        
        NetworkManager.requestPOSTURL(Constants.APIServices.DataById, params: self.param, headers: nil, success: { (responseJSON) in
            Utility.hideLoader()
            let responseArray = responseJSON.arrayObject!
            if responseArray.count > 0 {
                self.place.removeAll()
                for obj in responseArray {
                    let temp = obj as! [String: Any]
                    let rowNumber = temp["RowNumber"] as? Int
                    let totalCount = temp["TotalCount"] as? Int
                    let amenityGeoID = temp["AmenityGeoId"] as? Int
                    let amenityTypeID = temp["AmenityTypeId"] as? Int
                    let sType  = temp["SType"] as? String
                    let welcomeDescription = temp["Description"] as? String
                    let amenityType = temp["AmenityType"] as? String
                    let lat1 = temp["Lat1"] as? String
                    let lng1 = temp["Lng1"] as? String
                    let fuRL = temp["fuRL"] as? String
                    let distance = temp["Distance"] as? Double
                    
                    let place = Place(rowNumber: rowNumber ?? 0, totalCount: totalCount ?? 0, amenityGeoID: amenityGeoID ?? 0, amenityTypeID: amenityTypeID ?? 0, sType: sType ?? "", welcomeDescription: welcomeDescription ?? "", amenityType: amenityType ?? "", lat1: lat1 ?? "", lng1: lng1 ?? "", fuRL: fuRL ?? "" , distance: distance ?? 0.0)
                    
                    self.place.append(place)
                }
                self.addMarker()
            } else {
                self.showAlertWithOk(title: "Info", message: "There is some issue. Please try after some time")
            }
        }) { (error) in
            print(error)
            Utility.hideLoader()
            self.showAlertWithOk(title: "Error", message: "User not found")
        }
    }
    
}



class CheckBox: UIButton {
    // Images
    let checkedImage = UIImage(named: "select")! as UIImage
    let uncheckedImage = UIImage(named: "unselect")! as UIImage
    
    // Bool property
    var isChecked: Bool = false {
        didSet {
            if isChecked == true {
                self.setImage(checkedImage, for: UIControl.State.normal)
            } else {
                self.setImage(uncheckedImage, for: UIControl.State.normal)
            }
        }
    }
        
    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        self.isChecked = false
    }
        
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}


class Place: Codable {
    let rowNumber, totalCount, amenityGeoID, amenityTypeID: Int
    let sType, welcomeDescription, amenityType, lat1: String
    let lng1: String
    let fuRL: String
    let distance: Double

    enum CodingKeys: String, CodingKey {
        case rowNumber = "RowNumber"
        case totalCount = "TotalCount"
        case amenityGeoID = "AmenityGeoId"
        case amenityTypeID = "AmenityTypeId"
        case sType = "SType"
        case welcomeDescription = "Description"
        case amenityType = "AmenityType"
        case lat1 = "Lat1"
        case lng1 = "Lng1"
        case fuRL
        case distance = "Distance"
    }

    init(rowNumber: Int, totalCount: Int, amenityGeoID: Int, amenityTypeID: Int, sType: String, welcomeDescription: String, amenityType: String, lat1: String, lng1: String, fuRL: String, distance: Double) {
        self.rowNumber = rowNumber
        self.totalCount = totalCount
        self.amenityGeoID = amenityGeoID
        self.amenityTypeID = amenityTypeID
        self.sType = sType
        self.welcomeDescription = welcomeDescription
        self.amenityType = amenityType
        self.lat1 = lat1
        self.lng1 = lng1
        self.fuRL = fuRL
        self.distance = distance
    }
}
