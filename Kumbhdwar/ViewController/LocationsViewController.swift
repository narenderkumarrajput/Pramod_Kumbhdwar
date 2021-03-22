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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.parseKm1ToMap()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
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
