import Foundation

struct Input: Decodable {
    var predicate: Predicate
    var outputFormat: OutputFormat
}

struct Predicate: Decodable {
    var startDate: Date
    var endDate: Date
}

enum OutputFormat: Decodable {
    case json
    case tsv
}

func decodeInput() throws -> Input {
    let arguments = CommandLine.arguments
    return arguments.count >= 3
        ? try decodeArgumentInput(arguments)
        : try decodeStdinInput()
}

func decodeArgumentInput(_ arguments: [String]) throws -> Input {
    let message = "Reading from standard input.\n"
    let data = Data(message.utf8)
    FileHandle.standardError.write(data)
    if arguments.count < 3 {
        throw InputError.invalidArguments
    }
    let rawStartDate = arguments[1]
    let rawEndDate = arguments[2]
    let formatter = ISO8601DateFormatter()
    guard
        let startDate = formatter.date(from: rawStartDate),
        let endDate = formatter.date(from: rawEndDate)
    else {
        throw InputError.invalidArguments
    }
    return Input(
        predicate: Predicate(startDate: startDate, endDate: endDate),
        outputFormat: arguments.contains("--tsv") ? .tsv : .json
    )
}

func decodeStdinInput() throws -> Input {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    let data = FileHandle.standardInput.availableData
    return try decoder.decode(Input.self, from: data)
}
