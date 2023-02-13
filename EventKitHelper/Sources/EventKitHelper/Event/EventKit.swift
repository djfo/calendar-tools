import EventKit

extension Event {
    init(ekEvent: EKEvent) {
        let title = ekEvent.structuredLocation?.title
        let coordinate = ekEvent.structuredLocation?.geoLocation?.coordinate
        self.init(
            title: ekEvent.title,
            startDate: ekEvent.startDate,
            endDate: ekEvent.endDate,
            timeZone: ekEvent.timeZone,
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
