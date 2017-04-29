import CoreLocation

open class GeocodeOptions: NSObject {

    public let query: String
    public var locale = "en"
    public var limit = 10
    public var debug = false
    public var point: CLLocationCoordinate2D?
    public var provider = "default"

    public init(_ query: String) {
        assert(!query.isEmpty, "Specify a query.")
        self.query = query
    }

    public init(_ query: String, point: CLLocationCoordinate2D) {
        self.query = query
        self.point = point
    }

    public convenience init(_ query: String, location: CLLocation) {
        self.init(query, point: location.coordinate)
    }

    internal var params: [URLQueryItem] {
        var params: [URLQueryItem] = [
            URLQueryItem(name: "q", value: String(query)),
            URLQueryItem(name: "locale", value: locale),
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "debug", value: String(debug)),
            URLQueryItem(name: "provider", value: provider)
        ]

        if let point = point {
            params.append(URLQueryItem(name: "point", value: "\(String(point.latitude)),\(String(point.longitude))"))
        }

        return params
    }

    internal func response(_ json: JSONDictionary) -> ([Placemark]?) {
        return (json["hits"] as? [JSONDictionary])?.flatMap({ jsonPath in
            return Placemark(json: jsonPath, withOptions: self)
        })
    }
}
