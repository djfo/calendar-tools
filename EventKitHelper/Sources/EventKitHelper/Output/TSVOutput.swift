import Foundation

class TSVOutput: Output {
    private let dateFormatter = ISO8601DateFormatter()

    func output(event: Event) throws {
        var record: [String] = []

        record.append(event.title)
        record.append(event.timeZone?.identifier ?? "")
        record.append(self.dateFormatter.string(from: event.startDate))
        record.append(self.dateFormatter.string(from: event.endDate))
        if let location = event.location {
            record.append(location.title)
            if let coordinate = location.coordinate {
                record.append(String(coordinate.longitude))
                record.append(String(coordinate.latitude))
            } else {
                record.append("")
                record.append("")
            }
        } else {
            record.append("")
            record.append("")
            record.append("")
        }

        for value in record {
            if value.range(of: "(\t\n\r)", options: .regularExpression) != nil {
                let message = "Fields in TSV output cannot contain tabs, newlines, or carriage returns. Use JSON output format instead."
                throw OutputError.generic(message: message)
            }
        }

        let data = Data(record.joined(separator: "\t").appending("\n").utf8)
        FileHandle.standardOutput.write(data)
    }
}
