import Foundation

enum InputError: Error {
    case invalidArguments
    case invalidOutputFormat(raw: String)
}

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

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        switch raw.lowercased() {
            case "json":
                self = .json
            case "tsv":
                self = .tsv
            default:
                throw InputError.invalidOutputFormat(raw: raw)
        }
    }
}

func decodeInput() throws -> Input {
    let arguments = CommandLine.arguments
    return arguments.count >= 3
        ? try decodeArguments(arguments)
        : try decodeStandardInput()
}

func decodeArguments(_ arguments: [String]) throws -> Input {
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

func decodeStandardInput() throws -> Input {
    let message = "Reading from standard input.\n"
    FileHandle.standardError.write(Data(message.utf8))

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601

    let data = FileHandle.standardInput.availableData
    return try decoder.decode(Input.self, from: data)
}
