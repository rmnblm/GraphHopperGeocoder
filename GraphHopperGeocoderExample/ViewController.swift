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
//        let query = "Berlin"
//        let forwardGeocodeOptions = ForwardGeocodeOptions(query)

        let lat = CLLocationDegrees(exactly: 46.80907)
        let lng = CLLocationDegrees(exactly: 9.78098)

//        let point = CLLocationCoordinate2D(latitude: lat!, longitude: lng!)
//        let forwardGeocodeOptions = ForwardGeocodeOptions(query, location: location)
//
//        let location = CLLocation(latitude: lat!, longitude: lng!)
//        let forwardGeocodeOptions = ForwardGeocodeOptions(query, point: point)

        // Reverse Geocoding
        let point = CLLocationCoordinate2D(latitude: lat!, longitude: lng!)
        let reverseGeocodeOptions = ReverseGeocodeOptions(point: point)

        _ = geocoder.calculate(reverseGeocodeOptions, completionHandler: { (placemarks, error) in
            placemarks?.forEach({
                print("\nPlacemark:")
                print("\($0.point.latitude) \($0.point.longitude)")
                print($0.osmId)
                print($0.osmType)
                print($0.osmKey)
                print($0.osmValue)
                print($0.name)
                print($0.city)
                print($0.state)
                print($0.country)
            })
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
