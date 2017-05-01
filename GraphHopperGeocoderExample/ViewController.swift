//
//  ViewController.swift
//  GraphHopperGeocoderExample
//
//  Created by Phil Schilter on 29.04.17.
//  Copyright © 2017 Phil Schilter. All rights reserved.
//

import UIKit
import CoreLocation
import GraphHopperGeocoder

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let accessToken = "GRAPHHOPPER_ACCESS_TOKEN"
        let geocoder = Geocoder(accessToken: accessToken)

        // Forward Geocoding
        let query = "Hotel Strela"
        let forwardGeocodeOptions = ForwardGeocodeOptions(query: query)

//        let lat = CLLocationDegrees(exactly: 46.80907)
//        let lng = CLLocationDegrees(exactly: 9.78098)

//        let coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: lng!)
//        let forwardGeocodeOptions = ForwardGeocodeOptions(query, location: location)
//
//        let location = CLLocation(latitude: lat!, longitude: lng!)
//        let forwardGeocodeOptions = ForwardGeocodeOptions(query, point: point)

        // Reverse Geocoding
//        let coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: lng!)
//        let reverseGeocodeOptions = ReverseGeocodeOptions(coordinate: coordinate)

        _ = geocoder.geocode(forwardGeocodeOptions, completionHandler: { (placemarks, error) in
            placemarks?.forEach({
                print("\n")
                print("Point: \t\t\($0.coordinate.latitude),\($0.coordinate.longitude)")
                print("OSM ID: \t\t\($0.osmId ?? 0)")
                print("OSM Type: \t\($0.osmType ?? "")")
                print("OSM Key: \t\($0.osmKey ?? "")")
                print("OSM Value: \t\($0.osmValue ?? "")")
                print("Name: \t\t\($0.name ?? "")")
                print("Address: \t\($0.postalAddress?.street ?? "")")
                print("City: \t\t\($0.postalAddress?.postalCode ?? "") \($0.postalAddress?.city ?? "")")
                print("State: \t\t\($0.postalAddress?.state ?? "")")
                print("Country: \t\($0.postalAddress?.country ?? "")")
                if let region = $0.region {
                    print("Region: \t\tNorthWest: \(region[0].latitude) \(region[0].longitude) \tSouthEast: \(region[1].latitude) \(region[1].longitude)")
                }
            })
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
