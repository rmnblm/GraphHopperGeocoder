import CoreLocation
import Contacts

open class Placemark {
    fileprivate let json: JSONDictionary

    internal init(json: JSONDictionary) {
        self.json = json
    }

    public convenience init(placemark: Placemark) {
        self.init(json: placemark.json)
    }

    open var coordinate: CLLocationCoordinate2D {
        var coordinate = CLLocationCoordinate2D()

        if let pointJson = json["point"] as? JSONDictionary {
            if let lat = pointJson["lat"] as? CLLocationDegrees, let lng = pointJson["lng"] as? CLLocationDegrees {
                coordinate.latitude = lat
                coordinate.longitude = lng
            }
        }

        return coordinate
    }

    open var osmId: Int? {
        return json["osm_id"] as? Int
    }

    open var osmType: String? {
        return json["osm_type"] as? String
    }

    open var osmKey: String? {
        return json["osm_key"] as? String
    }

    open var osmValue: String? {
        return json["osm_value"] as? String
    }

    open var name: String? {
        return json["name"] as? String
    }

    open var housenumber: String? {
        return json["housenumber"] as? String
    }

    open var street: String? {
        return json["street"] as? String
    }

    open var postalCode: String? {
        return json["postcode"] as? String
    }

    open var city: String? {
        return json["city"] as? String
    }

    open var state: String? {
        return json["state"] as? String
    }

    open var country: String? {
        return json["country"] as? String
    }

    open var postalAddress: CNPostalAddress? {
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
