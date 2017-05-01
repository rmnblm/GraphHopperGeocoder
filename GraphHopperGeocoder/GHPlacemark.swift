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

    open var region: [CLLocationCoordinate2D]? {
        guard let boundingBox = json["extent"] as? [CLLocationDegrees] else {
            return nil
        }

        assert(boundingBox.count == 4, "Region should have coordinates for north-west and south-east")
        let northWest = CLLocationCoordinate2D(json: Array(boundingBox.prefix(2)))
        let southEast = CLLocationCoordinate2D(json: Array(boundingBox.suffix(2)))
        return [northWest, southEast]
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
        postalAddress.street = "\(street ?? "")\(housenumber == nil ? "" : " \(housenumber!)")"
        postalAddress.city = city ?? ""
        postalAddress.state = state ?? ""
        postalAddress.postalCode = postalCode ?? ""
        postalAddress.country = country ?? ""
        return postalAddress
    }
}

extension CLLocationCoordinate2D {
    internal init(json array: [CLLocationDegrees]) {
        assert(array.count == 2, "Coordinate must have latitude and longitude")
        self.init(latitude: array[1], longitude: array[0])
    }
}
