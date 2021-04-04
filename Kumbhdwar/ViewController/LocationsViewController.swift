//
//  LocationsViewController.swift
//  Kumbhdwar
//
//  Created by Narender Kumar on 18/03/21.
//  Copyright © 2021 Narender Kumar. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import GoogleMapsUtils

//https://developers.google.com/maps/documentation/ios-sdk/utility/kml-geojson
class LocationsViewController: UIViewController {
    
    let kmlFileName = "kumbh_facilities"
    let kmlFileType = "kmz"
    //var polygonView : GMSPolygon!
    //var polygonCoordinatePoints : [CLLocationCoordinate2D] = []
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var tblView: UITableView!
    var locationManager = CLLocationManager()
    var detailsArray: [Any] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Locations"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = AppStyleGuide.NewUI.Colors.appBg
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "ic_arrow_back_white_24dp"), for: .normal)
        button.addTarget(self, action:#selector(self.backAction), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItems = [barButton]
        
        self.tblView.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //self.parseKm1ToMap()
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
    
    func showMamberList(_ detailsArry: [Any]) {
        if detailsArry.count > 0 {
            self.detailsArray = detailsArry
            self.tblView.isHidden = false
            self.tblView.dataSource = self
            self.tblView.delegate = self
            
            let seconds = 0.2
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                self.tblView.reloadData()
                self.showMember()
            }
        }
    }
    
    private func showMember() {
        /*
         ["Lng": 78.3655564, "TotalCount": 5, "GroupType": FRIEND, "Lat": 17.4458714, "UserTrackGId": 1019, "RowNumber": 1, "Name": Raj, "ContactNo": 9599913932, "UserTrackPId": 1037]
         */
        var bounds = GMSCoordinateBounds()
        for temp in self.detailsArray {
            let user = temp as? [String: AnyObject]
            let latStr = user?["Lat"] as? String
            let lngStr  = user?["Lng"] as? String
            let lat = Double(latStr ?? "0.0")
            let lng = Double(lngStr ?? "0.0")
            let latLng = CLLocationCoordinate2DMake(lat!, lng!)

            let marker = GMSMarker(position: latLng)
            marker.icon = GMSMarker.markerImage(with: UIColor.red)
            marker.title = user?["ContactNo"] as? String
            marker.map = mapView
            mapView.selectedMarker = marker

            bounds = bounds.includingCoordinate(latLng)
        }
        
        let seconds = 0.5
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [self] in
            let update = GMSCameraUpdate.fit(bounds, withPadding: 30)
            mapView.animate(with: update)
        }
            
    }
    
    func parseKm1ToMap() {
        
        let path = Bundle.main.path(forResource: kmlFileName, ofType: kmlFileType)
        let url = URL(fileURLWithPath: path!)
        
       let  kmlParseMngr = GMUKMLParser(url: url)
        kmlParseMngr.parse()
        
        //kmlParseMngr.placemarks
        
        let renderer = GMUGeometryRenderer(map: mapView, geometries: kmlParseMngr.placemarks, styles: kmlParseMngr.styles)
        renderer.render()
    

    }
}

extension LocationsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.detailsArray.count
    }
    
    /*
     ["Lng": 78.3655564, "TotalCount": 5, "GroupType": FRIEND, "Lat": 17.4458714, "UserTrackGId": 1019, "RowNumber": 1, "Name": Raj, "ContactNo": 9599913932, "UserTrackPId": 1037]
     */
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let details = detailsArray[indexPath.row] as? [String : Any]
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if( !(cell != nil)) {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        }
        
        cell?.imageView?.image = UIImage(named: "mapMarker")
        cell!.textLabel?.text = details?["Name"] as? String
        cell?.backgroundView?.backgroundColor = .clear
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = self.detailsArray[indexPath.row] as? [String: AnyObject]

        let latStr = user?["Lat"] as? String
        let lngStr  = user?["Lng"] as? String
        let lat = Double(latStr ?? "0.0")
        let lng = Double(lngStr ?? "0.0")
        let latLng = CLLocationCoordinate2DMake(lat!, lng!)
        
        let camera = GMSCameraPosition.camera(withLatitude: latLng.latitude, longitude: latLng.longitude, zoom: 17.0)
        self.mapView?.animate(to: camera)
    }
    
    
}


extension LocationsViewController: CLLocationManagerDelegate {
    
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


/*
func parseKmlToMap() { // THE PATH TO THE KML FILE IN XCODE PROJECT
 let path = Bundle.main.path(forResource: kmlFileName, ofType: kmlFileType) // CONVERTING THE PATH TO URL
 let url = URL(fileURLWithPath: path!) // INITIALIZING KMLPARSER WITH THE UTL kmlParseMngr = KMLParser(url: url) // CALLING THE PARSEKML() FUNC FROM APPLE'S SAMPLE CODE kmlParseMngr.parseKML() // RECEIVING THE RESPOND WITH THE OVERLAY OF THE POLYGON let overlay : MKOverlay = km1ParseMngr.overlays[0] as! MKOverlay // ADDING THE OVERLAY TO YOUR MK MAP mapViewOutlet.addOverlay(overlay) let flyTo = overlay.boundingMapRect // MAKING THE MAP FIX ON THE POLYGON mapViewOutlet.visibleMapRect = flyTo
}
// ASKS THE DELEGATE FOR A RENDER OBJECT TO USE WHEN DRAWING THE SPECIFIED OVERLAY. func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) —> MKOverlayRenderer {
polygonView = MKPolygonRenderer(overlay: overlay) polygonView.fillColor = Ad polygonView.strokeColor = II polygonView.lineWidth = 2
return polygonView
}
*/
