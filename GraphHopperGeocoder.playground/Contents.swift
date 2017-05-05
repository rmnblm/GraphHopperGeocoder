import CoreLocation
import GraphHopperGeocoder
import PlaygroundSupport

let accessToken = "GRAPHHOPPER_ACCESS_TOKEN"
let geocoder = Geocoder(accessToken: accessToken)

let query = "HSR, Rapperswil"
let forwardGeocodeOptions = ForwardGeocodeOptions(query: query)
forwardGeocodeOptions.limit = 3

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
            print("Region: \t\tNorthWest: \(region.northWest.latitude) \(region.northWest.longitude) \tSouthEast: \(region.southEast.latitude) \(region.southEast.longitude)")
        }
    })
})

PlaygroundPage.current.needsIndefiniteExecution = true
