import Foundation

struct Predicate: Decodable {
    var startDate: Date
    var endDate: Date
}

struct Input: Decodable {
    var predicate: Predicate
}
