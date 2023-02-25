import EventKit
import Foundation

enum OutputMode {
    case json
}

class EventKitHelper {
    private let store = EKEventStore()
    private let output: Output

    init(outputMode: OutputMode) {
        switch outputMode {
            case .json:
                self.output = JSONOutput()
        }
    }

    func run(predicate: Predicate) {
        store.requestAccess(to: .event) { [weak self] (accessGranted, error) in
            if !accessGranted {
                if let error = error {
                    print(error.localizedDescription)
                }
                exit(1)
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
            print("Failed to output JSON.")
            exit(1)
        }

        exit(0)
    }
}

