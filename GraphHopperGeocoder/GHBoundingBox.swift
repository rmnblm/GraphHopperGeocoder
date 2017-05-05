//
//  GHBoundingBox.swift
//  GraphHopperRouting
//
//  Created by Roman Blum on 05.05.17.
//  Copyright © 2017 rmnblm. All rights reserved.
//

import CoreLocation

open class BoundingBox {
    open let northWest: CLLocationCoordinate2D
    open let southEast: CLLocationCoordinate2D

    internal init(northWest: CLLocationCoordinate2D, southEast: CLLocationCoordinate2D) {
        self.northWest = northWest
        self.southEast = southEast
    }

    public convenience init?(degrees: [CLLocationDegrees]) {
        guard degrees.count == 4 else {
            return nil
        }

        self.init(
            northWest: CLLocationCoordinate2D(latitude: degrees[0], longitude: degrees[1]),
            southEast: CLLocationCoordinate2D(latitude: degrees[2], longitude: degrees[3])
        )
    }
}
