import CoreLocation
import Contacts

open class Placemark {

    open let coordinate: CLLocationCoordinate2D

    fileprivate let json: JSONDictionary

    internal init(_ coordinate: CLLocationCoordinate2D, json: JSONDictionary) {
        self.coordinate = coordinate
        self.json = json
    }

    public convenience init?(json: JSONDictionary) {
        guard let pointJson = json["point"] as? JSONDictionary,
            let lat = pointJson["lat"] as? CLLocationDegrees,
            let lng = pointJson["lng"] as? CLLocationDegrees else {
            return nil
        }

        self.init(CLLocationCoordinate2D(latitude: lat, longitude: lng), json: json)
    }

    open lazy var osmId: Int? = {
        return self.json["osm_id"] as? Int
    }()

    open var osmType: String? {
        return json["osm_type"] as? String
    }

    open var osmKey: String? {
        return json["osm_key"] as? String
    }

    open var osmValue: String? {
        return json["osm_value"] as? String
    }

    open lazy var region: BoundingBox? = {
        guard let boundingBox = self.json["extent"] as? [CLLocationDegrees] else {
            return nil
        }
        return BoundingBox(degrees: boundingBox)
    }()

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
