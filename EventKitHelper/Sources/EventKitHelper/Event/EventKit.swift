import EventKit

extension Event {
    init(ekEvent: EKEvent) {
        let timeZone = ekEvent.timeZone.flatMap { tz in _TimeZone(timeZone: tz) }

        let title = ekEvent.structuredLocation?.title
        let coordinate = ekEvent.structuredLocation?.geoLocation?.coordinate
        let location = title.flatMap { t in
            Location(
                title: t,
                coordinate: coordinate.flatMap{
                    c in Coordinate(clLocationCoordinate2D: c)
                }
            )
        }

        self.init(
            title: ekEvent.title,
            startDate: ekEvent.startDate,
            endDate: ekEvent.endDate,
            timeZone: timeZone,
            location: location
        )
    }
}

extension _TimeZone {
    init(timeZone: TimeZone) {
        self.identifier = timeZone.identifier
    }
}
