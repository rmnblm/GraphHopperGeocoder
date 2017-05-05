import CoreLocation
import GraphHopperGeocoder
import PlaygroundSupport

let accessToken = "GRAPHHOPPER_ACCESS_TOKEN"
let geocoder = Geocoder(accessToken: accessToken)

let query = "HSR, Rapperswil"
let options = ForwardGeocodeOptions(query: query)

_ = geocoder.geocode(options, completionHandler: { (placemarks, error) in
    placemarks?.forEach({ placemark in
        print(placemark.name ?? "")
        print("\(placemark.coordinate.latitude), \(placemark.coordinate.longitude)")
    })
})

PlaygroundPage.current.needsIndefiniteExecution = true
