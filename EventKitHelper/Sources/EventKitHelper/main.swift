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

    let outputFormat: OutputFormat
    if arguments.contains("--tsv") {
        outputFormat = .tsv
    } else {
        outputFormat = .json
    }

    let helper = EventKitHelper(outputFormat: outputFormat)
    helper.run(predicate: input.predicate)

    autoreleasepool {
        RunLoop.main.run()
    }
} catch {
    die(message: "Failed to parse input.")
}

func decodeInput() throws -> Input {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    let data = FileHandle.standardInput.availableData
    return try decoder.decode(Input.self, from: data)
}
