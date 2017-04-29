import CoreLocation

open class Placemark {
    public let point: CLLocationCoordinate2D
    public let osmId: String
    public let name: String
    public let country: String
    public let city: String

    internal init(_ point: CLLocationCoordinate2D, osmId: String, name: String, country: String, city: String) {
        self.point = point
        self.osmId = osmId
        self.name = name
        self.country = country
        self.city = city
    }

    public convenience init?(json: JSONDictionary, withOptions options: GeocodeOptions) {
        var point = CLLocationCoordinate2D()

        if let pointJson = json["point"] as? JSONDictionary {
            if let lat = pointJson["lat"] as? CLLocationDegrees, let lng = pointJson["lng"] as? CLLocationDegrees {
                point.latitude = lat
                point.longitude = lng
            }
        }

        let osmId = json["osmId"] as? String ?? ""
        let name = json["name"] as? String ?? ""
        let country = json["country"] as? String ?? ""
        let city = json["city"] as? String ?? ""

        self.init(point, osmId: osmId, name: name, country: country, city: city)
    }
}
