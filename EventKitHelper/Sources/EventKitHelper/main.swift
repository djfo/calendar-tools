import Foundation

enum InputError: Error {
    case invalidArguments
}

do {
    let arguments = CommandLine.arguments

    let input: Input
    if arguments.count >= 3 {
        let rawStartDate = arguments[1]
        let rawEndDate = arguments[2]
        let formatter = ISO8601DateFormatter()
        guard
            let startDate = formatter.date(from: rawStartDate),
            let endDate = formatter.date(from: rawEndDate)
        else {
            throw InputError.invalidArguments
        }
        input = Input(predicate: Predicate(startDate: startDate, endDate: endDate))
    } else {
        input = try decodeInput()
    }

    let outputMode: OutputMode
    if arguments.contains("--tsv") {
        outputMode = .tsv
    } else {
        outputMode = .json
    }

    let helper = EventKitHelper(outputMode: outputMode)
    helper.run(predicate: input.predicate)

    autoreleasepool {
        RunLoop.main.run()
    }
} catch {
    print("Failed to parse input.")
    exit(1)
}

func decodeInput() throws -> Input {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    let data = FileHandle.standardInput.availableData
    return try decoder.decode(Input.self, from: data)
}
