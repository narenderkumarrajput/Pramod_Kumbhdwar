//
//  GMSMapViewHelper.swift
//  Kumbhdwar
//
//  Created by Narender Kumar on 16/03/21.
//  Copyright © 2021 Narender Kumar. All rights reserved.
//

import Foundation
import GoogleMaps

private struct MapPath : Decodable{
    var routes : [Route]?
}

private struct Route : Decodable{
    var overview_polyline : OverView?
}

private struct OverView : Decodable {
    var points : String?
}

extension GMSMapView {

    //MARK:- Call API for polygon points

    func drawPolygon(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        guard let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=driving&key=\(Constants.Google.ApiKey)") else {
            return
        }

        DispatchQueue.main.async {

            session.dataTask(with: url) { (data, response, error) in

                guard data != nil else {
                    return
                }
                do {

                    let route = try JSONDecoder().decode(MapPath.self, from: data!)

                    if let points = route.routes?.first?.overview_polyline?.points {
                        self.drawPath(with: points)
                    }
                    print(route.routes?.first?.overview_polyline?.points as Any)

                } catch let error {

                    print("Failed to draw ",error.localizedDescription)
                }
                }.resume()
            }
    }

    //MARK:- Draw polygon

    private func drawPath(with points : String){

        DispatchQueue.main.async {
            let path = GMSPath(fromEncodedPath: points)
            let polyline = GMSPolyline(path: path)
            polyline.strokeWidth = 3.0
            polyline.strokeColor = .blue
            polyline.map = self
        }
    }
}
