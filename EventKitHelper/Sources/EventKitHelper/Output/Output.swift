enum OutputError: Error {
    case generic(message: String)
}

protocol Output {
    func output(event: Event) throws
}
