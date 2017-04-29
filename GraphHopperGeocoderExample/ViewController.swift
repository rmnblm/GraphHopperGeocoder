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
        let query = "Berlin"
        let lat = CLLocationDegrees(exactly: 45.93272)
        let lng = CLLocationDegrees(exactly: 11.58803)
        let location = CLLocation(latitude: lat!, longitude: lng!)
        let point = CLLocationCoordinate2D(latitude: lat!, longitude: lng!)

        var options = GeocodeOptions(query)
        options = GeocodeOptions("Berlin", point: point)
        options = GeocodeOptions("Berlin", location: location)

        _ = geocoder.calculate(options, completionHandler: { (placemarks, error) in
            placemarks?.forEach({
                print("\($0.point.latitude) \($0.point.longitude)")
                print($0.osmId)
                print($0.name)
                print($0.country)
                print($0.city)
            })
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
