//
//  MapViewController.swift
//  Kumbhdwar
//
//  Created by Narender Kumar on 16/03/21.
//  Copyright © 2021 Narender Kumar. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    var latLong: CLLocationCoordinate2D =  CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    var latLongParking: CLLocationCoordinate2D =  CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    var locationManager = CLLocationManager()
    var mapTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = mapTitle
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = AppStyleGuide.NewUI.Colors.appBg
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "ic_arrow_back_white_24dp"), for: .normal)
        button.addTarget(self, action:#selector(self.backAction), for: .touchUpInside) 
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItems = [barButton]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.showUserLocationOnMap()
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
    
    private func drawPathOnMap(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        mapView.drawPolygon(from: source, to: destination)
        
        var bounds = GMSCoordinateBounds()
        bounds = bounds.includingCoordinate(source)
        bounds = bounds.includingCoordinate(destination)
        
        mapView.setMinZoom(1, maxZoom: 15)
        let update = GMSCameraUpdate.fit(bounds, withPadding: 50)
        mapView.animate(with: update)
    }
    
    private func putMarkerOnMap(_ userLocation: CLLocationCoordinate2D, destinationLocation: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: userLocation)
        marker.icon = GMSMarker.markerImage(with: UIColor.blue)
        marker.title = "Start"
        marker.map = mapView
        mapView.selectedMarker = marker
        
        let dMarker = GMSMarker(position: destinationLocation)
        dMarker.title = "Destination"
        dMarker.map = mapView
        mapView.selectedMarker = dMarker
        
        if latLongParking.latitude != 0.0 {
            let pMarker = GMSMarker(position: latLongParking)
            pMarker.title = "Parking"
            pMarker.map = mapView
            mapView.selectedMarker = pMarker
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
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
        
        self.putMarkerOnMap(location!.coordinate, destinationLocation: self.latLong)
        self.drawPathOnMap(from: location!.coordinate, to: self.latLong)
        
        if latLongParking.latitude != 0.0 {
            self.drawPathOnMap(from: location!.coordinate, to: self.latLongParking)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("issue in get location")
    }
    
}


