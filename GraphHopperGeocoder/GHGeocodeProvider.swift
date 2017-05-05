/**
 A provider to use when geocoding.
 */
public enum GeocodeProvider: String {
    /**
     This provider returns results of our internal geocoding engine.
     */
    case graphhopper = "default"

    /**
     This provider returns results from a nominatim geocoder
     */
    case nominatim = "nominatim"

    /**
     This provider returns results from the OpenCageData geocoder.
     */
    case opencagedata = "opencagedata"
}
