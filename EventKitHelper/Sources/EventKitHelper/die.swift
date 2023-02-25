import Foundation

func die(message: String) {
    let data = Data(message.utf8)
    FileHandle.standardOutput.write(data)
    exit(1)
}

func die(error: Error) {
    die(message: error.localizedDescription)
}
