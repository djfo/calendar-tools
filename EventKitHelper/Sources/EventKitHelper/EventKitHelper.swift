import EventKit
import Foundation

class EventKitHelper {
    private let store = EKEventStore()
    private let jsonEncoder: JSONEncoder

    init() {
        self.jsonEncoder = JSONEncoder()
        self.jsonEncoder.dateEncodingStrategy = .iso8601
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
                let data = try jsonEncoder.encode(event)
                try FileHandle.standardOutput.write(contentsOf: data)
                try FileHandle.standardOutput.write(contentsOf: "\n".data(using: .ascii)!)
            }
        } catch {
            print("Failed to output JSON.")
            exit(1)
        }

        exit(0)
    }
}

