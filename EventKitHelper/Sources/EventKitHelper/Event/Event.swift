import CoreLocation
import Foundation

struct Event: Encodable {
    var title: String
    var startDate: Date
    var endDate: Date
    var timeZone: TimeZone?
    var location: Location?
}

struct Location: Encodable {
    var title: String
    var coordinate: Coordinate?
}

struct Coordinate: Encodable {
    var longitude: Double
    var latitude: Double

    init(clLocationCoordinate2D: CLLocationCoordinate2D) {
        self.longitude = clLocationCoordinate2D.longitude
        self.latitude = clLocationCoordinate2D.latitude
    }
}
