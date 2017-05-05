import CoreLocation

#if !os(tvOS)
    import Contacts
#endif

/**
 A `Placemark` object represents a geocoder result containing geographic information for a particular coordinate (longitude/latitude).
 */
open class Placemark {

    fileprivate let json: JSONDictionary

    /**
     Initializes a new placemark object with the given JSON dictionary representation.

     - paramter json: A JSON dictionary representation of a placemark object as returnd by the GraphHopper Geocoding API.
     */
    public init(json: JSONDictionary) {
        self.json = json
    }

    /**
     The position of the address.
     */
    open lazy var coordinate: CLLocationCoordinate2D = {
        guard let pointJson = self.json["point"] as? JSONDictionary,
            let lat = pointJson["lat"] as? CLLocationDegrees,
            let lng = pointJson["lng"] as? CLLocationDegrees else {
                return CLLocationCoordinate2D()
        }

        return CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }()

    /**
     The OSM ID of the entity.
     */
    open lazy var osmId: Int? = {
        return self.json["osm_id"] as? Int
    }()

    /**

     */
    open lazy var osmType: String? = {
        return self.json["osm_type"] as? String
    }()

    /**

     */
    open lazy var osmKey: String? = {
        return self.json["osm_key"] as? String
    }()

    /**

     */
    open lazy var osmValue: String? = {
        return self.json["osm_value"] as? String
    }()

    /**
     The region of the placemark.
     */
    open lazy var region: BoundingBox? = {
        guard let boundingBox = self.json["extent"] as? [CLLocationDegrees] else {
            return nil
        }
        return BoundingBox(degrees: boundingBox)
    }()

    /**
     The name of the entity. Can be a boundary, POI, address, etc.
     */
    open lazy var name: String = {
        return self.json["name"] as? String ?? ""
    }()

    /**
     The house number of the address.
     */
    open lazy var housenumber: String = {
        return self.json["housenumber"] as? String ?? ""
    }()

    /**
     The street of the address.
     */
    open lazy var street: String = {
        return self.json["street"] as? String ?? ""
    }()

    /**
     The postal code of the address.
     */
    open lazy var postalCode: String = {
        return self.json["postcode"] as? String ?? ""
    }()

    /**
     The city of the address.
     */
    open lazy var city: String = {
        return self.json["city"] as? String ?? ""
    }()

    /**
     The state of the address.
     */
    open lazy var state: String = {
        return self.json["state"] as? String ?? ""
    }()

    /**
     The country of the address.
     */
    open lazy var country: String = {
        return self.json["country"] as? String ?? ""
    }()

    #if !os(tvOS)
    /**
     The placemark’s postal address.
     */
    @available(iOS 9.0, OSX 10.11, *)
    open lazy var postalAddress: CNPostalAddress? = {
        let postalAddress = CNMutablePostalAddress()
        let streetAndHouseNumber = "\(self.street) \(self.housenumber)"
        postalAddress.street = streetAndHouseNumber.isEmpty ? "" : streetAndHouseNumber
        postalAddress.city = self.city
        postalAddress.state = self.state
        postalAddress.postalCode = self.postalCode
        postalAddress.country = self.country
        return postalAddress
    }()
    #endif
}
