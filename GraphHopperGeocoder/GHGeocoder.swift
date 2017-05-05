import Foundation

public typealias JSONDictionary = [String: Any]

let GHGeocoderErrorDomain = "GHGeocoderErrorDomain"
let defaultAccessToken = Bundle.main.object(forInfoDictionaryKey: "GraphHopperAccessToken") as? String
let defaultApiVersion = "1"

open class Geocoder: NSObject {

    public typealias CompletionHandler = (_ placemark: [Placemark]?, _ error: Error?) -> Void

    open static let shared = Geocoder(accessToken: nil)

    internal let accessToken: String
    internal let baseURL: URL

    public init(accessToken: String?, apiVersion: String? = nil) {
        guard let token = accessToken ?? defaultAccessToken else {
            fatalError("You must provide an access token in order to use the GraphHopper Geocoding API.")
        }

        self.accessToken = token

        var baseURLComponents = URLComponents()
        baseURLComponents.scheme = "https"
        baseURLComponents.host = "graphhopper.com"
        baseURLComponents.path = "/api/\(apiVersion ?? defaultApiVersion)/geocode"
        self.baseURL = baseURLComponents.url!
    }

    open func geocode(_ options: GeocodeOptions, completionHandler: @escaping CompletionHandler) -> URLSessionDataTask {
        let url = urlForGeocoding(options)
        let task = dataTask(withURL: url, completionHandler: { (json) in
            let response = options.response(json)
            completionHandler(response, nil)
        }) { (error) in
            completionHandler(nil, error)
        }
        task.resume()
        return task
    }

    fileprivate func dataTask(
        withURL url: URL,
        completionHandler: @escaping (_ json: JSONDictionary) -> Void,
        errorHandler: @escaping (_ error: Error) -> Void) -> URLSessionDataTask {

        return URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard let data = data, response?.mimeType == "application/json" else {
                assert(false, "Invalid data.")
                return
            }

            var json: JSONDictionary = [:]

            do {
                json = try JSONSerialization.jsonObject(with: data, options: []) as! JSONDictionary
            } catch {
                assert(false, "Unable to parse JSON.")
            }

            let apiMessage = json["message"] as? String
            guard error == nil && apiMessage == nil else {
                let apiError = Geocoder.descriptiveError(json, response: response, underlyingerror: error as NSError?)
                DispatchQueue.main.async {
                    errorHandler(apiError)
                }
                return
            }

            DispatchQueue.main.async {
                completionHandler(json)
            }
        })
    }

    open func urlForGeocoding(_ options: GeocodeOptions) -> URL {
        let params = options.params + [
            URLQueryItem(name: "key", value: accessToken),
        ]

        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)!
        components.queryItems = params
        return components.url!
    }

    static func descriptiveError(_ json: JSONDictionary, response: URLResponse?, underlyingerror error: NSError?) -> NSError {
        var userInfo = error?.userInfo ?? [:]
        if let response = response as? HTTPURLResponse {
            var failureReason: String? = nil
            var recoverySuggestion: String? = nil

            switch response.statusCode {
            case 429:
                if let creditLimit = response.creditLimit {
                    let formattedCount = NumberFormatter.localizedString(from: creditLimit as NSNumber, number: .decimal)
                    failureReason = "More than \(formattedCount) requests have been made with this access token."
                }
                if let timeUntilReset = response.timeUntilReset {
                    let intervalFormatter = DateComponentsFormatter()
                    intervalFormatter.unitsStyle = .full
                    let formattedSeconds = intervalFormatter.string(from: timeUntilReset) ?? "\(timeUntilReset) seconds"
                    recoverySuggestion = "Wait \(formattedSeconds) before retrying."
                }
            default:
                failureReason = json["message"] as? String
            }
            userInfo[NSLocalizedFailureReasonErrorKey] = failureReason ?? userInfo[NSLocalizedFailureReasonErrorKey] ?? HTTPURLResponse.localizedString(forStatusCode: error?.code ?? -1)
            userInfo[NSLocalizedRecoverySuggestionErrorKey] = recoverySuggestion ?? userInfo[NSLocalizedRecoverySuggestionErrorKey]
        }

        if let error = error {
            userInfo[NSUnderlyingErrorKey] = error
        }

        return NSError(domain: error?.domain ?? GHGeocoderErrorDomain, code: error?.code ?? -1, userInfo: userInfo)
    }
}

extension HTTPURLResponse {
    var creditLimit: UInt? {
        guard let limit = allHeaderFields["X-RateLimit-Limit"] as? String else {
            return nil
        }

        return UInt(limit)
    }

    var remainingCredits: UInt? {
        guard let credits = allHeaderFields["X-RateLimit-Remaining"] as? String else {
            return nil
        }

        return UInt(credits)
    }

    var timeUntilReset: TimeInterval? {
        guard let time = allHeaderFields["X-RateLimit-Reset"] as? String else {
            return nil
        }

        return TimeInterval(time)
    }

    var creditCosts: Double? {
        guard let costs = allHeaderFields["X-RateLimit-Credits"] as? String else {
            return nil
        }

        return Double(costs)
    }
}
