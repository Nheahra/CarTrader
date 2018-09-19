import Foundation

enum SortOption: String, Codable, CaseIterable {
    case lowestToHighestInPrice
    case aToZForMake
    case aToZForModel
    case oldestToNewest
    
    var displayName: String {
        switch self {
        case .lowestToHighestInPrice:
            return "Price: Lowest to Highest"
        case .aToZForMake:
            return "Make: A to Z"
        case .aToZForModel:
            return "Model: A to Z"
        case .oldestToNewest:
            return "Oldest to Newest"
        }
    }
    static func optionFor(key: String) -> SortOption? {
        return SortOption.allCases.first(where: {key == $0.rawValue})
    }
}
