import CoreLocation
import GraphHopperGeocoder
import PlaygroundSupport

let accessToken = "GRAPHHOPPER_ACCESS_TOKEN"
let geocoder = Geocoder(accessToken: accessToken)

let query = "HSR, Rapperswil"
let forwardGeocodeOptions = ForwardGeocodeOptions(query: query)

_ = geocoder.geocode(forwardGeocodeOptions, completionHandler: { (placemarks, error) in
    placemarks?.forEach({
        print("\n")
        print("Point: \t\t\($0.coordinate.latitude),\($0.coordinate.longitude)")
        print("OSM ID: \t\t\($0.osmId ?? 0)")
        print("OSM Type: \t\($0.osmType ?? "")")
        print("OSM Key: \t\($0.osmKey ?? "")")
        print("OSM Value: \t\($0.osmValue ?? "")")
        print("Name: \t\t\($0.name)")
        print("Address: \t\($0.street)")
        print("City: \t\t\($0.postalCode) \($0.city)")
        print("State: \t\t\($0.state)")
        print("Country: \t\($0.country)")
        if let region = $0.region {
            print("Region: \t\tNorthWest: \(region.topLeft.latitude) \(region.topLeft.longitude) \tSouthEast: \(region.bottomRight.latitude) \(region.bottomRight.longitude)")
        }
    })
})

PlaygroundPage.current.needsIndefiniteExecution = true
