import XCTest
@testable import GraphHopperGeocoder

class GeocoderTests: XCTestCase {

    override func setUp() {
        NSTimeZone.default = TimeZone(secondsFromGMT: 0)!
    }

    override func tearDown() {
        super.tearDown()
    }

    func testConfiguration() {
        let accessToken = "my-awesome-test-token"
        let geocoder = Geocoder(accessToken: accessToken)
        XCTAssertEqual(geocoder.accessToken, accessToken)
        XCTAssertEqual(geocoder.baseURL.absoluteString, "https://graphhopper.com/api/1/geocode")
    }

    func testRateLimitErrorParsing() {
        let json = ["message": "Hit rate limit"]

        let url = URL(string: "https://graphhopper.com/api/1/geocode")!
        let headerFields = ["X-RateLimit-Limit": "300", "X-RateLimit-Reset": "300"]
        let response = HTTPURLResponse(url: url, statusCode: 429, httpVersion: nil, headerFields: headerFields)

        let error: NSError? = nil

        let resultError = Geocoder.descriptiveError(json, response: response, underlyingerror: error)

        XCTAssertEqual(resultError.localizedFailureReason!, "More than 300 requests have been made with this access token.")
        XCTAssertEqual(resultError.localizedRecoverySuggestion!, "Wait 5 minutes before retrying.")
    }
}
