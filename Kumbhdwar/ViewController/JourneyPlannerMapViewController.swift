//
//  JourneyPlannerMapViewController.swift
//  Kumbhdwar
//
//  Created by Narender Kumar on 30/03/21.
//  Copyright © 2021 Narender Kumar. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class JourneyPlannerMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var personalBtn: UIButton!
    @IBOutlet weak var walkBtn: UIButton!
    
    var locationManager = CLLocationManager()
    var detailDict:[String : Any] = [:]
    var isCameraMove = false
    var myLocation = CLLocationCoordinate2D()
    var parkingLocation = CLLocationCoordinate2D()
    var routeStartLocation = CLLocationCoordinate2D()
    var routeEndLocation = CLLocationCoordinate2D()
    var route:[MyRoute] = []
    var routeData: RouteData? = nil
    var vPath: [CLLocationCoordinate2D] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Route"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = AppStyleGuide.NewUI.Colors.appBg
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "ic_arrow_back_white_24dp"), for: .normal)
        button.addTarget(self, action:#selector(JourneyPlannerMapViewController.backAction), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItems = [barButton]
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.showUserLocationOnMap()
        self.getPlannerPhaseWise()
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
    
    
    private func setVpath(_ pathString: String) {

        let pString = pathString.split(separator: ",")
        for temp in pString {
            let pArray = temp.split(separator: " ")
            let lng = Double(pArray.first ?? "0.0")!
            let lat = Double(pArray.last ?? "0.0")!
            vPath.append(CLLocationCoordinate2DMake(lat, lng))
        }
        
        self.drawPath(vPath)

    }
    
    @IBAction func personalAction(_ sender: UIButton) {
        for temp in self.route {
            if temp.modeOfTravel == "PERSONAL VEHICLE" {
                if temp.rFile.count > 5 {
                    self.getAllPlannerRoute(temp.rFile)
                }
                
                mapView.clear()
                
                let seconds = 0.4
                DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                    self.parkingLocation = CLLocationCoordinate2D(latitude: temp.parkingLat, longitude: temp.parkingLng)
                    self.setMarker(self.parkingLocation, name: "Parking", color: .red)
                    
                    self.routeStartLocation = CLLocationCoordinate2D(latitude: temp.routeSLat, longitude: temp.routeSLng)
                    self.setMarker(self.routeStartLocation, name: "Route Start", color: .orange)
                    
                    self.routeEndLocation = CLLocationCoordinate2D(latitude: temp.routeEndLat, longitude: temp.routeEndLng)
                    self.setMarker(self.routeEndLocation, name: "Route End", color: .orange)
                }
                
                if temp.vPath.count > 5 {
                    self.setVpath(temp.vPath)
                }
                
                if let _ = routeData {
                    let features = routeData?.features.first
                    if let coordinates = features?.geometry.coordinates {
                        var finalCoordinate: [CLLocationCoordinate2D] = []
                        for cord in coordinates {
                            finalCoordinate.append(CLLocationCoordinate2D(latitude: cord.last!, longitude: cord.first!))
                        }
                        self.drawPath(finalCoordinate)
                    }
                }
                
                break
            }
        }
    }
    
    @IBAction func walkAction(_ sender: UIButton) {
        for temp in self.route {
            if temp.modeOfTravel == "WALKING"  {
                if temp.rFile.count > 5 {
                    self.getAllPlannerRoute(temp.rFile)
                }
                
                mapView.clear()
                
                let seconds = 0.4
                DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                    self.parkingLocation = CLLocationCoordinate2D(latitude: temp.parkingLat, longitude: temp.parkingLng)
                    self.setMarker(self.parkingLocation, name: "Parking", color: .red)
                    
                    self.routeStartLocation = CLLocationCoordinate2D(latitude: temp.routeSLat, longitude: temp.routeSLng)
                    self.setMarker(self.routeStartLocation, name: "Route Start", color: .red)
                    
                    self.routeEndLocation = CLLocationCoordinate2D(latitude: temp.routeEndLat, longitude: temp.routeEndLng)
                    self.setMarker(self.routeEndLocation, name: "Route End", color: .red)
                }
                
                if temp.vPath.count > 5 {
                    self.setVpath(temp.vPath)
                }
                
                break
            }
        }
    }
    
    
    func drawPath(_ pointsArray: [CLLocationCoordinate2D]) {
        let path = GMSMutablePath()
        for temp in pointsArray {
            path.add(temp)
        }
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 4.0
        polyline.strokeColor = .blue
        polyline.map = mapView
    }
    
    func setMarker(_ location: CLLocationCoordinate2D, name: String, color: UIColor ) {
        let marker = GMSMarker(position: location)
        marker.icon = GMSMarker.markerImage(with: color)
        marker.title = name
        marker.map = mapView
        mapView.selectedMarker = marker
    }

}



extension JourneyPlannerMapViewController: CLLocationManagerDelegate {
    
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
        if !isCameraMove {
            let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)
            self.mapView?.animate(to: camera)
            //self.locationManager.stopUpdatingLocation()
        }
        
        let marker = GMSMarker(position: location!.coordinate)
        marker.icon = GMSMarker.markerImage(with: UIColor.blue)
        marker.title = "ME"
        marker.map = mapView
        mapView.selectedMarker = marker
        
        self.myLocation = location!.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("issue in get location")
    }
    
}

extension JourneyPlannerMapViewController {
    
    /*
     ["VisitorName": Amrender, "VisitingDate": 2021-03-22T00:00:00, "ParkingLat": 29.9391569129101, "ParkingName": Rishikul 2 ISBT Parking, "JourneyPlanId": 1010, "TravelModeId": 4, "SourceAddress": Delhi, "Remark": , "SourceLat": 28.6862738, "DestinationGhatName": Naya Govindpuri Ghat, "DestinationGhatLng": 78.137860040310201, "AccompanyingPersons": 5, "VehicleNo": Hm5566, "TravelMode": PERSONAL VEHICLE, "SourceLng": 77.2217831, "DestinationGhatLat": 29.9311985149604, "ePass": , "VisitorId": 6262151234, "ParkingLng": 78.141458047571803]
     */
    
    func getPlannerPhaseWise() {
        Utility.showLoaderWithTextMsg(text: "")
        
        let param = ["ContactNo": self.detailDict["VisitorId"], "JourneyPlanId": self.detailDict["JourneyPlanId"]] as? [String: AnyObject]
        NetworkManager.requestPOSTURL(Constants.APIServices.getAllPlannerPhaseWise, params: param, headers: nil, success: { (responseJSON) in
            Utility.hideLoader()
            let responseArray = responseJSON.arrayObject
            
            if responseArray?.count ?? 0 > 0 {
                for temp1 in responseArray! {
                    print(temp1)
                    let temp = temp1 as? [String: Any]
                    let ParkingLng = temp?["ParkingLng"] as? Double ?? 0.0
                    let VPath = temp?["VPath"] as? String ?? ""
                    let RouteEndLat = temp?["RouteEndLat"] as? Double ?? 0.0
                    let ID = temp?["ID"] as? Int ?? 0
                    let Description = temp?["Description"] as? String ?? ""
                    let ModeOfTravel = temp?["ModeOfTravel"] as? String ?? ""
                    let RouteEndLng = temp?["RouteEndLng"] as? Double ?? 0.0
                    let ParkingLat = temp?["ParkingLat"] as? Double ?? 0.0
                    let RouteSLat = temp?["RouteSLat"] as? Double ?? 0.0
                    let RouteSLng = temp?["RouteSLng"] as? Double ?? 0.0
                    let RFile = temp?["RFile"] as? String ?? ""
                    let ParkingName = temp?["ParkingName"] as? String ?? ""
                    
                    let route = MyRoute(parkingLng: ParkingLng, vPath: VPath, routeEndLat: RouteEndLat, id: ID, welcomeDescription: Description, modeOfTravel: ModeOfTravel, routeEndLng: RouteEndLng, parkingLat: ParkingLat, routeSLat: RouteSLat, routeSLng: RouteSLng, rFile: RFile, parkingName: ParkingName)
                    
                    self.route.append(route)
                    
                }
            } else {
                self.showAlertWithOk(title: "Info", message: "There is some issue. Please try after some time")
            }
        }) { (error) in
            print(error)
            Utility.hideLoader()
            self.showAlertWithOk(title: "Error", message: "User not found")
        }
    }
    
    
    func getAllPlannerRoute(_ urlStr: String) {
        let headers = ["Authorization":"Basic cGF0bmE6cGF0bmEjMjAyMA==","Content-Type":"application/json"] as [String:String]
        Utility.showLoaderWithTextMsg(text: "Loading...")
        let urlString = urlStr
        NetworkManager.requestGETURL(urlString, headers: headers) { (responseJSON) in
            Utility.hideLoader()
            print(responseJSON)
            let jsonData = try? responseJSON.rawData()
            self.routeData = try! JSONDecoder().decode(RouteData.self, from: jsonData!)
            print(self.routeData)
        } failure: { (error) in
            print(error)
            Utility.hideLoader()
        }
    }
    
}



class MyRoute: Codable {
    let parkingLng: Double
    let vPath: String
    let routeEndLat: Double
    let id: Int
    let welcomeDescription, modeOfTravel: String
    let routeEndLng, parkingLat, routeSLat, routeSLng: Double
    let rFile: String
    let parkingName: String

    enum CodingKeys: String, CodingKey {
        case parkingLng = "ParkingLng"
        case vPath = "VPath"
        case routeEndLat = "RouteEndLat"
        case id = "ID"
        case welcomeDescription = "Description"
        case modeOfTravel = "ModeOfTravel"
        case routeEndLng = "RouteEndLng"
        case parkingLat = "ParkingLat"
        case routeSLat = "RouteSLat"
        case routeSLng = "RouteSLng"
        case rFile = "RFile"
        case parkingName = "ParkingName"
    }

    init(parkingLng: Double, vPath: String, routeEndLat: Double, id: Int, welcomeDescription: String, modeOfTravel: String, routeEndLng: Double, parkingLat: Double, routeSLat: Double, routeSLng: Double, rFile: String, parkingName: String) {
        self.parkingLng = parkingLng
        self.vPath = vPath
        self.routeEndLat = routeEndLat
        self.id = id
        self.welcomeDescription = welcomeDescription
        self.modeOfTravel = modeOfTravel
        self.routeEndLng = routeEndLng
        self.parkingLat = parkingLat
        self.routeSLat = routeSLat
        self.routeSLng = routeSLng
        self.rFile = rFile
        self.parkingName = parkingName
    }
}





// MARK: -
struct RouteData: Codable {
    let type, name: String
    let crs: CRS
    let features: [Feature]
}

// MARK: - CRS
struct CRS: Codable {
    let type: String
    let properties: CRSProperties
}

// MARK: - CRSProperties
struct CRSProperties: Codable {
    let name: String
}

// MARK: - Feature
struct Feature: Codable {
    let type: String
    let properties: FeatureProperties
    let geometry: Geometry
}

// MARK: - Geometry
struct Geometry: Codable {
    let type: String
    let coordinates: [[Double]]
}

// MARK: - FeatureProperties
struct FeatureProperties: Codable {
    let name, propertiesDescription: JSONNull?

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case propertiesDescription = "description"
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
