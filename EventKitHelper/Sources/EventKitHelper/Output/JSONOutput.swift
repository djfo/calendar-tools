import Foundation

class JSONOutput: Output {
    private let jsonEncoder: JSONEncoder

    init() {
        self.jsonEncoder = JSONEncoder()
        self.jsonEncoder.dateEncodingStrategy = .iso8601
    }

    func output(event: Event) throws {
        let data = try jsonEncoder.encode(event)
        try FileHandle.standardOutput.write(contentsOf: data)
        try FileHandle.standardOutput.write(contentsOf: "\n".data(using: .ascii)!)
    }
}
