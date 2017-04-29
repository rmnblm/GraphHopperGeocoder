//
//  ViewController.swift
//  GraphHopperGeocoderExample
//
//  Created by Phil Schilter on 29.04.17.
//  Copyright © 2017 Phil Schilter. All rights reserved.
//

import UIKit
import GraphHopperGeocoder

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let accessToken = "GRAPHHOPPER_ACCESS_TOKEN"
        let geocoder = Geocoder(accessToken: accessToken)
        let query = "Berlin"
        let options = GeocodeOptions(query)
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
