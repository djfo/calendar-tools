import EventKit

extension Event {
    init(ekEvent: EKEvent) {
        let title = ekEvent.structuredLocation?.title
        let coordinate = ekEvent.structuredLocation?.geoLocation?.coordinate
        self.init(
            title: ekEvent.title,
            startDate: ekEvent.startDate,
            endDate: ekEvent.endDate,
            timeZone: ekEvent.timeZone.flatMap { tz in _TimeZone(timeZone: tz) },
            location: title.flatMap { t in
                Location(
                    title: t,
                    coordinate: coordinate.flatMap{
                        c in Coordinate(clLocationCoordinate2D: c)
                    }
                )
            }
        )
    }
}

extension _TimeZone {
    init(timeZone: TimeZone) {
        self.identifier = timeZone.identifier
    }
}
