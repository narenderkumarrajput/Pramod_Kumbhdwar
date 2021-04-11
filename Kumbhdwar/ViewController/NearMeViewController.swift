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
import Localize_Swift

class NearMeViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var hospitalBtn: CheckBox! //ATM
    @IBOutlet weak var policeBtn: CheckBox! //Hospital
    @IBOutlet weak var vendingZoneBtn: CheckBox! //Hotel
    @IBOutlet weak var toiletBtn: CheckBox! //Petrol Pump
    @IBOutlet weak var railwayStationBtn: CheckBox! //Local Eateries
    private var locationManager = CLLocationManager()
    private var param:[String: AnyObject] = [:]
    private var place:[Place] = []
    private var isFirst = true
    private var myLocation = CLLocationCoordinate2D()
    private var placeLoc:[CLLocationCoordinate2D] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "NEAR ME".localized()
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
        
        if let lang = UserDefaults.standard.object(forKey: "Lang") as? String {
            Localize.setCurrentLanguage(lang)
            self.setTextOnView()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setTextOnView() {
        self.hospitalBtn.setTitle("ATM".localized(), for: .normal)
        self.policeBtn.setTitle("Hospital".localized(), for: .normal)
        self.vendingZoneBtn.setTitle("Hotel".localized(), for: .normal)
        self.toiletBtn.setTitle("Petrol Pump".localized(), for: .normal)
        self.railwayStationBtn.setTitle("Local Eateries".localized(), for: .normal)
        
        /*
         hospitalBtn: CheckBox! //ATM
         policeBtn: CheckBox! //Hospital
         vendingZoneBtn: CheckBox! //Hotel
         toiletBtn: CheckBox! //Petrol Pump
         railwayStationBtn: CheckBox! //Local Eateries
         */
    }
    
    private func googleUrl(_ latLngWithComa: String, type: String) ->String {
        return "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latLngWithComa)&radius=5000&type=\(type)&sensor=true&key=\(Constants.Google.ApiKey)"
        //https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=27.93616,76.2665579&radius=5000&type=local_eateries&sensor=true&key=AIzaSyCbDwPN59e4wcuNqJEbCd3yTq2tYOvP3JU
        
        //https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=27.93616,76.2665579&radius=5000&type=local_eateries&sensor=true&key=AIzaSyCbDwPN59e4wcuNqJEbCd3yTq2tYOvP3JU
        
        //"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=27.099861,76.244217&radius=5000&type=hospital&sensor=true&key=AIzaSyBkbFZnaMrHcaSgmPWle6Mv5e5eVwP-Hww"
        // iOS
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
        //5-atm 6-hospital 7-restaurant 8-gas_station 9-local_eateries
        //param["AmenityTypeId"] = String(sender.tag) as AnyObject
        //self.showPlaces()
        self.mapView.clear()
        let latlong = "\(myLocation.latitude),\(myLocation.longitude)"
        var gUrlStr = ""
        switch sender.tag {
        case 5:
            gUrlStr = self.googleUrl(latlong, type: "atm")
        case 6:
            gUrlStr = self.googleUrl(latlong, type: "hospital")
        case 7:
            gUrlStr = self.googleUrl(latlong, type: "restaurant")
        case 8:
            gUrlStr = self.googleUrl(latlong, type: "gas_station")
        case 9:
            gUrlStr = self.googleUrl(latlong, type: "local_eateries")
        default:
            break
        }
        
        self.getPlace(gUrlStr)
    }
    
    func getPlace(_ urlStr: String) {
        var request = URLRequest(url: URL(string: urlStr)!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            print(String(decoding: data, as: UTF8.self))
            

            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    // try to read out a string array
                    if let results = json["results"] as? [[String: Any]] {
                        self.placeLoc.removeAll()
                        for temp in results {
                            if let geometry = temp["geometry"] as? [String: Any] {
                                if let location = geometry["location"] as? [String: Any] {
                                    let lat = location["lat"] as? Double
                                    let lng = location["lng"] as? Double
                                    self.placeLoc.append(CLLocationCoordinate2D(latitude: lat ?? 0.0, longitude: lng ?? 0.0))
                                }
                            }
                        }
                        DispatchQueue.main.async {
                            self.showPlacesLocationOnMap()
                        }
                    }
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            
            
            
            /*
            for temp in r.results {
                self.placeLoc.append(CLLocationCoordinate2D(latitude: temp.geometry.location.lat, longitude: temp.geometry.location.lng))
            }
            DispatchQueue.main.async {
                self.showPlacesLocationOnMap()
            }
            */
            
            
            
            /*
            do {
                if self.placeLoc.count > 0 {
                    self.placeLoc.removeAll()
                }
                let decoder = JSONDecoder()
                let r = try decoder.decode(GoogleData.self, from: data)
                print(r.results.first?.geometry.location)
                if r.results.count > 0 {
                    for temp in r.results {
                        self.placeLoc.append(CLLocationCoordinate2D(latitude: temp.geometry.location.lat, longitude: temp.geometry.location.lng))
                    }
                    DispatchQueue.main.async {
                        self.showPlacesLocationOnMap()
                    }
                    
                }
            } catch {}
            */
        }
        
        task.resume()
    }
    
    private func showPlacesLocationOnMap() {
        var bounds = GMSCoordinateBounds()
        for user in self.placeLoc {
            let marker = GMSMarker(position: user)
            marker.icon = GMSMarker.markerImage(with: UIColor.red)
            //marker.title = user.name
            marker.map = mapView
            mapView.selectedMarker = marker
            
            bounds = bounds.includingCoordinate(user)
        }
        
        let seconds = 0.5
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [self] in
            let update = GMSCameraUpdate.fit(bounds, withPadding: 30)
            mapView.animate(with: update)
        }
            
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
        //self.locationManager.stopUpdatingLocation()
        
        myLocation = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        
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


















// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let googleData = try GoogleData(json)

import Foundation

// MARK: - GoogleData
struct GoogleData: Codable {
    let htmlAttributions: [JSONAny]
    let nextPageToken: String
    let results: [Result]
    let status: String

    enum CodingKeys: String, CodingKey {
        case htmlAttributions = "html_attributions"
        case nextPageToken = "next_page_token"
        case results, status
    }
}

// MARK: GoogleData convenience initializers and mutators

extension GoogleData {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(GoogleData.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        htmlAttributions: [JSONAny]? = nil,
        nextPageToken: String? = nil,
        results: [Result]? = nil,
        status: String? = nil
    ) -> GoogleData {
        return GoogleData(
            htmlAttributions: htmlAttributions ?? self.htmlAttributions,
            nextPageToken: nextPageToken ?? self.nextPageToken,
            results: results ?? self.results,
            status: status ?? self.status
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Result
struct Result: Codable {
    let businessStatus: BusinessStatus
    let geometry: GeometryG
    let icon: String
    let name, placeID: String
    let plusCode: PlusCode
    let rating: Double?
    let reference: String
    let scope: Scope
    let types: [TypeElement]
    let userRatingsTotal: Int?
    let vicinity: String
    let openingHours: OpeningHours?
    let photos: [Photo]?

    enum CodingKeys: String, CodingKey {
        case businessStatus = "business_status"
        case geometry = "geometry"
        case icon, name
        case placeID = "place_id"
        case plusCode = "plus_code"
        case rating, reference, scope, types
        case userRatingsTotal = "user_ratings_total"
        case vicinity
        case openingHours = "opening_hours"
        case photos
    }
}

// MARK: Result convenience initializers and mutators

extension Result {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Result.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        businessStatus: BusinessStatus? = nil,
        geometry: GeometryG? = nil,
        icon: String? = nil,
        name: String? = nil,
        placeID: String? = nil,
        plusCode: PlusCode? = nil,
        rating: Double?? = nil,
        reference: String? = nil,
        scope: Scope? = nil,
        types: [TypeElement]? = nil,
        userRatingsTotal: Int?? = nil,
        vicinity: String? = nil,
        openingHours: OpeningHours?? = nil,
        photos: [Photo]?? = nil
    ) -> Result {
        return Result(
            businessStatus: businessStatus ?? self.businessStatus,
            geometry: geometry ?? self.geometry,
            icon: icon ?? self.icon,
            name: name ?? self.name,
            placeID: placeID ?? self.placeID,
            plusCode: plusCode ?? self.plusCode,
            rating: rating ?? self.rating,
            reference: reference ?? self.reference,
            scope: scope ?? self.scope,
            types: types ?? self.types,
            userRatingsTotal: userRatingsTotal ?? self.userRatingsTotal,
            vicinity: vicinity ?? self.vicinity,
            openingHours: openingHours ?? self.openingHours,
            photos: photos ?? self.photos
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

enum BusinessStatus: String, Codable {
    case operational = "OPERATIONAL"
}

// MARK: - Geometry
struct GeometryG: Codable {
    let location: Location
    let viewport: Viewport
}

// MARK: Geometry convenience initializers and mutators

extension GeometryG {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(GeometryG.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        location: Location? = nil,
        viewport: Viewport? = nil
    ) -> GeometryG {
        return GeometryG (
            location: location ?? self.location,
            viewport: viewport ?? self.viewport
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Location
struct Location: Codable {
    let lat, lng: Double
}

// MARK: Location convenience initializers and mutators

extension Location {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Location.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        lat: Double? = nil,
        lng: Double? = nil
    ) -> Location {
        return Location(
            lat: lat ?? self.lat,
            lng: lng ?? self.lng
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Viewport
struct Viewport: Codable {
    let northeast, southwest: Location
}

// MARK: Viewport convenience initializers and mutators

extension Viewport {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Viewport.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        northeast: Location? = nil,
        southwest: Location? = nil
    ) -> Viewport {
        return Viewport(
            northeast: northeast ?? self.northeast,
            southwest: southwest ?? self.southwest
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - OpeningHours
struct OpeningHours: Codable {
    let openNow: Bool

    enum CodingKeys: String, CodingKey {
        case openNow = "open_now"
    }
}

// MARK: OpeningHours convenience initializers and mutators

extension OpeningHours {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(OpeningHours.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        openNow: Bool? = nil
    ) -> OpeningHours {
        return OpeningHours(
            openNow: openNow ?? self.openNow
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Photo
struct Photo: Codable {
    let height: Int
    let htmlAttributions: [String]
    let photoReference: String
    let width: Int

    enum CodingKeys: String, CodingKey {
        case height
        case htmlAttributions = "html_attributions"
        case photoReference = "photo_reference"
        case width
    }
}

// MARK: Photo convenience initializers and mutators

extension Photo {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Photo.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        height: Int? = nil,
        htmlAttributions: [String]? = nil,
        photoReference: String? = nil,
        width: Int? = nil
    ) -> Photo {
        return Photo(
            height: height ?? self.height,
            htmlAttributions: htmlAttributions ?? self.htmlAttributions,
            photoReference: photoReference ?? self.photoReference,
            width: width ?? self.width
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - PlusCode
struct PlusCode: Codable {
    let compoundCode, globalCode: String

    enum CodingKeys: String, CodingKey {
        case compoundCode = "compound_code"
        case globalCode = "global_code"
    }
}

// MARK: PlusCode convenience initializers and mutators

extension PlusCode {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PlusCode.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        compoundCode: String? = nil,
        globalCode: String? = nil
    ) -> PlusCode {
        return PlusCode(
            compoundCode: compoundCode ?? self.compoundCode,
            globalCode: globalCode ?? self.globalCode
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

enum Scope: String, Codable {
    case google = "GOOGLE"
}

enum TypeElement: String, Codable {
    case dentist = "dentist"
    case doctor = "doctor"
    case establishment = "establishment"
    case health = "health"
    case hospital = "hospital"
    case pointOfInterest = "point_of_interest"
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}
