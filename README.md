# GraphHopperGeocoder
🔍 The GraphHopper Geocoding API wrapped in an easy-to-use Swift framework.

The Geocoding API is part of the [GraphHopper Directions API](https://graphhopper.com/#directions-api). Geocoding is the process of finding an address for your geo location or a coordinate for an address. With our API you have a fast and solid way to geocode.

## Installation

Use [CocoaPods](http://cocoapods.org/) to install the framework. Add this to your Podfile:

``` ruby
pod 'GraphHopperGeocoder'
```

Then run the following command:

```
$ pod install
```

In order to use the framework, you'll also need a [GraphHopper Access Token](https://graphhopper.com/dashboard/#/api-keys). You can either set your access token in the `Info.plist` (Key is GraphHopperAccessToken) or pass it as an argument to the initializer of the `Geocoder` class.

## Example

### Basics

Setup the `Geocoder` class

``` swift
import GraphHopperGeocoder

// use this
let goecoder = Geocoder(accessToken: "YOUR ACCESS TOKEN")
// or if you have set your access token in the Info.plist
let geocoder = geocoder()
```

### Forward Geocoding

Configure the forward geocoding options

``` swift
let options = ForwardGeocodeOptions(query: "HSR Rapperswil")
options.limit = 3
```

Make the async request by calling the `calculate(_:completionHandler)` method

``` swift
let task = geocoder.geocode(options, completionHandler: { (placemarks, error) in
    placemarks?.forEach({ placemark in
        print(placemark.name)
        print("\(placemark.coordinate.latitude), \(placemark.coordinate.longitude)")
    })
})
```

For more information, consider the [official documentation](https://graphhopper.com/api/1/docs/#geocoding-api) to learn more about the options and the result.

### Reverse Geocoding

Configure the reverse geocoding options

```swift
let coordinate = CLLocationCoordinate2D(latitude: 47.222943, longitude: 8.817238649765951)
let options = ReverseGeocodeOptions(coordinate: coordinate)
```

Make the async request by calling the `calculate(_:completionHandler)` method

```swift
let task = geocoder.geocode(options, completionHandler: { (placemarks, error) in
    placemarks?.forEach({ placemark in
        print(placemark.name)
        print(placemark.postalAddress?.street)
        print(placemark.postalAddress?.postalCode)
        print(placemark.postalAddress?.city)
        print(placemark.postalAddress?.state)
        print(placemark.postalAddress?.country)
    })
})
```

For more information, consider the [official documentation](https://graphhopper.com/api/1/docs/#geocoding-api) to learn more about the options and the result.

## License

This project is released under the [MIT license](LICENSE)

## About

<img src="images/HSRLogo.png" width="184" />

​The GraphHopper Geocoder Swift Framework is crafted with ​:heart:​ by [@rmnblm](https://github.com/rmnblm) and [@iphilgood](https://github.com/rmnblm) during the Bachelor thesis at [HSR University of Applied Sciences](https://www.hsr.ch) in Rapperswil.
