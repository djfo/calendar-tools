import EventKit
import Foundation

enum OutputFormat {
    case json
    case tsv
}

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
        let predicate = store.predicateForEvents(
            withStart: predicate.startDate,
            end: predicate.endDate,
            calendars: nil
        )

        let events = store.events(matching: predicate)

        do {
            for ekEvent in events {
                let event = Event(ekEvent: ekEvent)
                try self.output.output(event: event)
            }
        } catch {
            die(message: "Failed to output JSON.")
        }

        exit(0)
    }
}

