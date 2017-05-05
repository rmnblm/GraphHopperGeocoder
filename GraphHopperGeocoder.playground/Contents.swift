import CoreLocation
import GraphHopperGeocoder
import PlaygroundSupport

let accessToken = "GRAPHHOPPER_ACCESS_TOKEN"
let geocoder = Geocoder(accessToken: accessToken)

let query = "HSR, Rapperswil"
var options: GeocodeOptions = ForwardGeocodeOptions(query: query)

print("====== Forward Geocode Results ======\n")
_ = geocoder.geocode(options, completionHandler: { (placemarks, error) in
    if let error = error {
        print(error.localizedDescription)
        return
    }

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
            print("Region: \t\tTop-left: \(region.topLeft.latitude) \(region.topLeft.longitude) \tBottom-right: \(region.bottomRight.latitude) \(region.bottomRight.longitude)")
        }
    })
})

print("\n\n")
print("====== Reverse Geocode Results ======\n")
options = ReverseGeocodeOptions(coordinate: CLLocationCoordinate2D(latitude: 47.222943, longitude: 8.817238649765951))
_ = geocoder.geocode(options, completionHandler: { (placemarks, error) in
    if let error = error {
        print(error.localizedDescription)
        return
    }
    
    placemarks?.forEach({ placemark in
        print(placemark.name)
        print("\(placemark.coordinate.latitude), \(placemark.coordinate.longitude)")
    })
})

PlaygroundPage.current.needsIndefiniteExecution = true
