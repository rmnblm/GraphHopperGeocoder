import CoreLocation

public enum GeocodeProvider: String {
    case graphhopper = "default"
    case nominatim = "nominatim"
    case opencagedata = "opencagedata"
}

open class GeocodeOptions: NSObject {
    public var locale: String?
    public var debug: Bool?
    public var provider: GeocodeProvider?

    internal var params: [URLQueryItem] {
        var params = [URLQueryItem]()

        if let locale = self.locale {
            params.append(URLQueryItem(name: "locale", value: locale))
        }

        if let debug = self.debug {
            params.append(URLQueryItem(name: "debug", value: String(debug)))
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

open class ForwardGeocodeOptions: GeocodeOptions {
    public let query: String
    public var limit: UInt?
    public var coordinate: CLLocationCoordinate2D?

    public init(query: String, coordinate: CLLocationCoordinate2D? = nil) {
        assert(!query.isEmpty, "Specify a query.")
        self.query = query
        self.coordinate = coordinate
        super.init()
    }

    public convenience init(query: String, location: CLLocation) {
        self.init(query: query, coordinate: location.coordinate)
    }

    override var params: [URLQueryItem] {
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

open class ReverseGeocodeOptions: GeocodeOptions {
    public let coordinate: CLLocationCoordinate2D
    public let reverse = true

    public init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init()
    }

    public convenience init(location: CLLocation) {
        self.init(coordinate: location.coordinate)
    }

    override var params: [URLQueryItem] {
        var params = super.params

        params.append(URLQueryItem(name: "point", value: "\(coordinate.latitude),\(coordinate.longitude)"))
        params.append(URLQueryItem(name: "reverse", value: String(reverse)))

        return params
    }
}

