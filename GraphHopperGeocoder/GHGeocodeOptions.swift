import CoreLocation

public enum GeocodeProvider: String {
    case graphhopper = "default"
    case nominatim = "nominatim"
    case opencagedata = "opencagedata"
}

open class GeocodeOptions: NSObject {

    public var locale = "en"
    public var debug = false
    public var provider: GeocodeProvider = .graphhopper

    internal var params: [URLQueryItem] {
        return [
            URLQueryItem(name: "locale", value: locale),
            URLQueryItem(name: "debug", value: String(debug)),
            URLQueryItem(name: "provider", value: provider.rawValue)
        ]
    }

    internal func response(_ json: JSONDictionary) -> ([Placemark]?) {
        return (json["hits"] as? [JSONDictionary])?.flatMap({ Placemark(json: $0) })
    }
}

open class ForwardGeocodeOptions: GeocodeOptions {

    public let query: String
    public var limit = 10
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

        var forwardGeocodingParams: [URLQueryItem] = [
            URLQueryItem(name: "q", value: String(query)),
            URLQueryItem(name: "limit", value: String(limit)),
        ]

        if let point = coordinate {
            forwardGeocodingParams.append(URLQueryItem(name: "point", value: "\(point.latitude),\(point.longitude)"))
        }

        params.append(contentsOf: forwardGeocodingParams)

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
        
        let reverseGeocodingParams: [URLQueryItem] = [
            URLQueryItem(name: "reverse", value: String(reverse)),
            URLQueryItem(name: "point", value: "\(coordinate.latitude),\(coordinate.longitude)")
        ]

        params.append(contentsOf: reverseGeocodingParams)

        return params
    }
}

