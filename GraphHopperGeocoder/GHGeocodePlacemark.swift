import CoreLocation

open class Placemark {
    public let point: CLLocationCoordinate2D
    public let osmId: Int
    public let osmType: String
    public let osmKey: String
    public let osmValue: String
    public let name: String
    public let city: String
    public let state: String
    public let country: String

    internal init(_ point: CLLocationCoordinate2D, osmId: Int, osmType: String, osmKey: String, osmValue: String, name: String, city: String, state: String, country: String) {
        self.point = point
        self.osmId = osmId
        self.osmType = osmType
        self.osmKey = osmKey
        self.osmValue = osmValue
        self.name = name
        self.city = city
        self.state = state
        self.country = country
    }

    public convenience init?(json: JSONDictionary, withOptions options: GeocodeOptions) {
        var point = CLLocationCoordinate2D()

        if let pointJson = json["point"] as? JSONDictionary {
            if let lat = pointJson["lat"] as? CLLocationDegrees, let lng = pointJson["lng"] as? CLLocationDegrees {
                point.latitude = lat
                point.longitude = lng
            }
        }

        let osmId = json["osmId"] as? Int ?? 0
        let osmType = json["osmType"] as? String ?? ""
        let osmKey = json["osmKey"] as? String ?? ""
        let osmValue = json["osmValue"] as? String ?? ""
        let name = json["name"] as? String ?? ""
        let city = json["city"] as? String ?? ""
        let state = json["state"] as? String ?? ""
        let country = json["country"] as? String ?? ""

        self.init(point, osmId: osmId, osmType: osmType, osmKey: osmKey, osmValue: osmValue, name: name, city: city, state: state, country: country)
    }
}
