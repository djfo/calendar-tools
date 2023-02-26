import Foundation

enum InputError: Error {
    case invalidArguments
}

do {
    let input = try decodeInput()

    let helper = EventKitHelper(outputFormat: input.outputFormat)
    helper.run(predicate: input.predicate)

    autoreleasepool {
        RunLoop.main.run()
    }
} catch {
    die(message: "Failed to decode input.")
}
