import CoreLocation

open class GeocodeOptions: NSObject {

    public let query: String
    public var locale = "en"
    public var limit = 10
    public var debug = false

    public init(_ query: String) {
        assert(!query.isEmpty, "Specify a query.")
        self.query = query
    }

    internal var params: [URLQueryItem] {
        let params: [URLQueryItem] = [
            URLQueryItem(name: "q", value: String(query)),
            URLQueryItem(name: "locale", value: locale),
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "debug", value: String(debug))
        ]

        return params
    }

    internal func response(_ json: JSONDictionary) -> ([Placemark]?) {
        return (json["hits"] as? [JSONDictionary])?.flatMap({ jsonPath in
            return Placemark(json: jsonPath, withOptions: self)
        })
    }
}
