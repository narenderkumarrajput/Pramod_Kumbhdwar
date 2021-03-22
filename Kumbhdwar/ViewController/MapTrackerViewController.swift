//
//  MapTrackerViewController.swift
//  Kumbhdwar
//
//  Created by Narender Kumar on 16/03/21.
//  Copyright © 2021 Narender Kumar. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class MapTrackerViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var addPersonBtn: UIButton!
    var locationManager = CLLocationManager()
    var mapTitle: String = ""
    var usersLocationsWithName: [UserLocation] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = mapTitle
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = AppStyleGuide.NewUI.Colors.appBg
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "ic_arrow_back_white_24dp"), for: .normal)
        button.addTarget(self, action:#selector(MapTrackerViewController.backAction), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItems = [barButton]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.showUserLocationOnMap()
        self.showOtherUsersLocationOnMap()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
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
    private func showOtherUsersLocationOnMap() {
        var bounds = GMSCoordinateBounds()
        for user in self.usersLocationsWithName {
            let marker = GMSMarker(position: user.latLong)
            marker.icon = GMSMarker.markerImage(with: UIColor.red)
            marker.title = user.name
            marker.map = mapView
            mapView.selectedMarker = marker
            
            bounds = bounds.includingCoordinate(user.latLong)
        }
        
        let seconds = 0.5
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [self] in
            let update = GMSCameraUpdate.fit(bounds, withPadding: 30)
            mapView.animate(with: update)
        }
            
    }
    
    @IBAction func addNewPersonAction(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        var mapVC = AddTrackerPersonVC()
        if #available(iOS 13.0, *) {
            mapVC = (sb.instantiateViewController(identifier: "AddTrackerPersonVC") as? AddTrackerPersonVC)!
        } else {
            mapVC = sb.instantiateViewController(withIdentifier: "AddTrackerPersonVC") as! AddTrackerPersonVC
        }
        self.navigationController?.pushViewController(mapVC, animated: true)
    }

}


extension MapTrackerViewController: CLLocationManagerDelegate {
    
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
        self.locationManager.stopUpdatingLocation()
        
        let marker = GMSMarker(position: location!.coordinate)
        marker.icon = GMSMarker.markerImage(with: UIColor.blue)
        marker.title = "ME"
        marker.map = mapView
        mapView.selectedMarker = marker
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("issue in get location")
    }
    
}



class UserLocation {
    var latLong: CLLocationCoordinate2D =  CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    var name: String = ""
    
    init(latLong: CLLocationCoordinate2D, name: String) {
        self.latLong = latLong
        self.name = name
    }
}
