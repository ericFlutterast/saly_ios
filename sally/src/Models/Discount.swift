import Foundation

struct Discount: Hashable {
    let id: String
    var description: String
    let companyName: String
    let discoutPercent: UInt8
    var isLiked: Bool = false
}

