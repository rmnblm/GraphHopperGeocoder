import CoreLocation

/**
 A `GeocodeOptions` object is used to specify user-defined options when querying the GraphHopper Geocoding API.
 
 Do not create instances of `GeocodeOptions` directly. Instead, create instances of `ForwardGeocodeOptions` or `ReverseGeocodeOptions`.
 */
open class GeocodeOptions: NSObject {
    /**
     Display the search results for the specified locale. If the locale wasn't found the default (en) is used.

     Uses the current language code by default.
     */
    public var locale: String? = Locale.current.languageCode

    /**
     The provider to use when starting a geocode request.

     Note: The provider parameter is currently under development and can fall back to default at any time. The intend is to provide alternatives to our default geocoder.
     Also currently only the default (`.graphhopper`) provider supports autocompletion of partial search strings.
     All providers support normal "forward" geocoding and reverse geocoding via reverse=true.
     */
    public var provider: GeocodeProvider?

    internal var params: [URLQueryItem] {
        var params = [URLQueryItem]()

        if let locale = self.locale {
            params.append(URLQueryItem(name: "locale", value: locale))
        }

        if let provider = self.provider {
            params.append(URLQueryItem(name: "provider", value: provider.rawValue))
        }

        return params
    }

    internal func response(_ json: JSONDictionary) -> ([Placemark]?) {
        return (json["hits"] as? [JSONDictionary])?.flatMap({ Placemark(json: $0) })
    }
}

/**
 A `ForwardGeocodeOptions` object is used to find a latitude/longitude pair for a given address.
 */
open class ForwardGeocodeOptions: GeocodeOptions {
    /**
     Specify an address
     */
    public let query: String

    /**
     Specify how many results you want
     */
    public var limit: UInt?

    /**
     The location bias.
     
     This property prioritizes results that are close to this coordinate, e.g. the user’s current location
     */
    public var coordinate: CLLocationCoordinate2D?

    /**
     Initializes a forward geocode options object with the given query and an optional location bias.

     - parameter query: A name or address to search for.
     - paramter location: A bias to prioritize results that are close to this coordinate.
     */
    public init(query: String, coordinate: CLLocationCoordinate2D? = nil) {
        assert(!query.isEmpty, "Specify a query.")
        self.query = query
        self.coordinate = coordinate
        super.init()
    }

    /**
     Initializes a forward geocode options object with the given query and a location bias.

     - parameter query: A name or address to search for.
     - paramter location: A bias to prioritize results that are close to this location.
     */
    public convenience init(query: String, location: CLLocation) {
        self.init(query: query, coordinate: location.coordinate)
    }

    internal override var params: [URLQueryItem] {
        var params = super.params

        params.append(URLQueryItem(name: "q", value: String(query)))

        if let limit = self.limit {
            params.append(URLQueryItem(name: "limit", value: String(limit)))
        }

        if let point = coordinate {
            params.append(URLQueryItem(name: "point", value: "\(point.latitude),\(point.longitude)"))
        }

        return params
    }
}

/**
 A `ReverseGeocodeOptions` object is used to find an address for a given latitude/longitude pair.
 */
open class ReverseGeocodeOptions: GeocodeOptions {
    /**
     The location to find amenities, cities etc.
     */
    public let coordinate: CLLocationCoordinate2D

    /**
     Initializes a reverse geocode options object with the given coordinate.

     - parameter coordinate: A coordinate to search the address for.
     */
    public init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init()
    }

    /**
     Initializes a reverse geocode options object with the given location.

     - parameter location: A location to search the address for.
     */
    public convenience init(location: CLLocation) {
        self.init(coordinate: location.coordinate)
    }

    internal override var params: [URLQueryItem] {
        var params = super.params

        params.append(URLQueryItem(name: "point", value: "\(coordinate.latitude),\(coordinate.longitude)"))
        params.append(URLQueryItem(name: "reverse", value: "true"))

        return params
    }
}

