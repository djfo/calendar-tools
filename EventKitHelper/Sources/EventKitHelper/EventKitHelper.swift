import EventKit
import Foundation

class EventKitHelper {
    private let store = EKEventStore()
    private let output: Output

    init(outputFormat: OutputFormat) {
        switch outputFormat {
            case .json:
                self.output = JSONOutput()
            case .tsv:
                self.output = TSVOutput()
        }
    }

    func run(predicate: Predicate) {
        store.requestAccess(to: .event) { [weak self] (accessGranted, error) in
            if !accessGranted {
                if let error = error {
                    die(error: error)
                } else {
                    die(message: "Access to calendar not granted.")
                }
            }
            self?._run(predicate: predicate)
        }
    }

    func _run(predicate: Predicate) {
        /*
         * The EventKit API restricts the maximum selectable time span to 4
         * years. We lift that restriction by breaking the input time span into
         * chunks and querying multiple times.
         *
         * https://developer.apple.com/documentation/eventkit/ekeventstore/1507479-predicateforevents#discussion
         */
        let timeSpans = timeSpans(
            from: predicate.startDate,
            to: predicate.endDate
        )

        do {
            for (startDate, endDate) in timeSpans {
                try self.process(from: startDate, to: endDate)
            }
        } catch {
            die(message: "Failed to output JSON.")
        }

        exit(0)
    }

    func process(from startDate: Date, to endDate: Date) throws {
        let predicate = store.predicateForEvents(
            withStart: startDate,
            end: endDate,
            calendars: nil
        )

        let events = store.events(matching: predicate)

        for ekEvent in events {
            let event = Event(ekEvent: ekEvent)
            try self.output.output(event: event)
        }
    }
}

func timeSpans(from startDate: Date, to endDate: Date) -> [(Date, Date)] {
    var timeSpans: [(Date, Date)] = []
    computeTimeSpans(startDate: startDate, endDate: endDate, acc: &timeSpans)
    return timeSpans
}

fileprivate func computeTimeSpans(startDate: Date, endDate: Date, acc: inout [(Date, Date)]) {
    let utc = TimeZone(identifier: "UTC")!
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = utc

    let nextDate = calendar.date(byAdding: .year, value: 4, to: startDate)!

    if nextDate < endDate {
        acc.append((startDate, nextDate))
        computeTimeSpans(startDate: nextDate, endDate: endDate, acc: &acc)
    } else {
        acc.append((startDate, endDate))
    }
}
