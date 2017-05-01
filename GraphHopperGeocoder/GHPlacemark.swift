import CoreLocation
import Contacts

open class Placemark {
    public let coordinate: CLLocationCoordinate2D
    public var osmId: Int?
    public var osmType: String?
    public var osmKey: String?
    public var osmValue: String?
    public var name: String?
    public var housenumber: String?
    public var street: String?
    public var postalCode: String?
    public var city: String?
    public var state: String?
    public var country: String?
    public var postalAddress: CNPostalAddress?

    internal init(_ coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }

    public convenience init?(json: JSONDictionary) {
        var coordinate = CLLocationCoordinate2D()

        if let pointJson = json["point"] as? JSONDictionary {
            if let lat = pointJson["lat"] as? CLLocationDegrees, let lng = pointJson["lng"] as? CLLocationDegrees {
                coordinate.latitude = lat
                coordinate.longitude = lng
            }
        }

        self.init(coordinate)

        osmId = json["osm_id"] as? Int
        osmType = json["osm_type"] as? String
        osmKey = json["osm_key"] as? String
        osmValue = json["osm_value"] as? String
        name = json["name"] as? String
        housenumber = json["housenumber"] as? String
        street = json["street"] as? String
        postalCode = json["postcode"] as? String
        city = json["city"] as? String
        state = json["state"] as? String
        country = json["country"] as? String

        var postalAddress: CNPostalAddress? {
            let postalAddress = CNMutablePostalAddress()

            if let street = json["street"] as? String {
                postalAddress.street = street

                if let housenumber = json["housenumber"] as? String {
                    postalAddress.street = "\(street) \(housenumber)"
                }
            }

            if let city = json["city"] as? String {
                postalAddress.city = city
            }

            if let state = json["state"] as? String {
                postalAddress.state = state
            }

            if let postalCode = json["postcode"] as? String {
                postalAddress.postalCode = postalCode
            }

            if let country = json["country"] as? String {
                postalAddress.country = country
            }

            return postalAddress
        }
    }
}
