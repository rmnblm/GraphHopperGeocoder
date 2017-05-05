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

    open lazy var osmType: String? = {
        return self.json["osm_type"] as? String
    }()

    open lazy var osmKey: String? = {
        return self.json["osm_key"] as? String
    }()

    open lazy var osmValue: String? = {
        return self.json["osm_value"] as? String
    }()

    open lazy var region: BoundingBox? = {
        guard let boundingBox = self.json["extent"] as? [CLLocationDegrees] else {
            return nil
        }
        return BoundingBox(degrees: boundingBox)
    }()

    open lazy var name: String? = {
        return self.json["name"] as? String
    }()

    open lazy var housenumber: String? = {
        return self.json["housenumber"] as? String
    }()

    open lazy var street: String? = {
        return self.json["street"] as? String
    }()

    open lazy var postalCode: String? = {
        return self.json["postcode"] as? String
    }()

    open lazy var city: String? = {
        return self.json["city"] as? String
    }()

    open lazy var state: String? = {
        return self.json["state"] as? String
    }()

    open lazy var country: String? = {
        return self.json["country"] as? String
    }()

    open lazy var postalAddress: CNPostalAddress? = {
        let postalAddress = CNMutablePostalAddress()
        postalAddress.street = "\(self.street ?? "")\(self.housenumber == nil ? "" : " \(self.housenumber!)")"
        postalAddress.city = self.city ?? ""
        postalAddress.state = self.state ?? ""
        postalAddress.postalCode = self.postalCode ?? ""
        postalAddress.country = self.country ?? ""
        return postalAddress
    }()
}

extension CLLocationCoordinate2D {
    internal init(json array: [CLLocationDegrees]) {
        assert(array.count == 2, "Coordinate must have latitude and longitude")
        self.init(latitude: array[1], longitude: array[0])
    }
}
