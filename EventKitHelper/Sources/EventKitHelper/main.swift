import Foundation

do {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    let data = FileHandle.standardInput.availableData
    let decoded = try decoder.decode(Input.self, from: data)

    let helper = EventKitHelper()
    helper.run(predicate: decoded.predicate)

    autoreleasepool {
        RunLoop.main.run()
    }
} catch {
    print("Failed to parse input.")
    exit(1)
}
