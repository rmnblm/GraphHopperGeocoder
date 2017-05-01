import CoreLocation

public enum GeocodeProvider: String {
    case graphhopper = "default"
    case nominatim = "nominatim"
    case opencagedata = "opencagedata"
}

open class GeocodeOptions: NSObject {

    public var coordinate: CLLocationCoordinate2D?
    public var locale = "en"
    public var debug = false
    public var provider: GeocodeProvider = .graphhopper

    internal var params: [URLQueryItem] {
        var params: [URLQueryItem] = [
            URLQueryItem(name: "locale", value: locale),
            URLQueryItem(name: "debug", value: String(debug)),
            URLQueryItem(name: "provider", value: provider.rawValue)
        ]

        if let point = coordinate {
            params.append(URLQueryItem(name: "point", value: "\(point.latitude),\(point.longitude)"))
        }

        return params
    }

    internal func response(_ json: JSONDictionary) -> ([Placemark]?) {
        return (json["hits"] as? [JSONDictionary])?.flatMap({ jsonPath in
            return Placemark(json: jsonPath)
        })
    }
}

open class ForwardGeocodeOptions: GeocodeOptions {

    public let query: String
    public var limit = 10

    public init(query: String) {
        assert(!query.isEmpty, "Specify a query.")
        self.query = query
        super.init()
    }

    public init(query: String, coordinate: CLLocationCoordinate2D) {
        assert(!query.isEmpty, "Specify a query.")
        self.query = query
        super.init()
        self.coordinate = coordinate
    }

    public convenience init(query: String, location: CLLocation) {
        self.init(query: query, coordinate: location.coordinate)
    }

    override var params: [URLQueryItem] {
        var params = super.params

        let forwardGeocodingParams: [URLQueryItem] = [
            URLQueryItem(name: "q", value: String(query)),
            URLQueryItem(name: "limit", value: String(limit)),
        ]

        params.append(contentsOf: forwardGeocodingParams)

        return params
    }
}

open class ReverseGeocodeOptions: GeocodeOptions {

    public let reverse = true

    public init(coordinate: CLLocationCoordinate2D) {
        super.init()
        self.coordinate = coordinate
    }

    public convenience init(location: CLLocation) {
        self.init(coordinate: location.coordinate)
    }

    override var params: [URLQueryItem] {
        var params = super.params
        
        let reverseGeocodingParams: [URLQueryItem] = [
            URLQueryItem(name: "reverse", value: String(reverse)),
        ]

        params.append(contentsOf: reverseGeocodingParams)

        return params
    }
}

