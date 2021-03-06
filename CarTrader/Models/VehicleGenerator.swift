import Foundation

enum Make: String, CaseIterable{
    case honda
    case volkswagen
    case acura
    case audi
    case bmw
    case buick
    case cadillac
    
    var randomModel: String {
        switch self {
        case .honda: return ["Civic","Accord","CR-V","Civic Type R", "Insight", "Odyssey"].randomElement()!
        case .volkswagen: return ["Passat", "Jetta", "Atlas", "Tiguan", "Beetle", "Golf", "Golf GTI"].randomElement()!
        case .acura: return ["MDX", "NSX", "TLX", "ILX", "RLX", "RLX Sport Hybrid"].randomElement()!
        case .audi: return ["A3", "A4", "A5", "A6", "A7", "A8", "R3", "RS3", "R5", "S8"].randomElement()!
        case .bmw: return ["3 Series", "5 Series", "X3", "i8"].randomElement()!
        case .buick: return ["Encore", "Envision", "Cascada", "Lacrosse", "Regal Sportback"].randomElement()!
        case .cadillac: return ["ATS", "ATS-V", "CTS", "CTS-V", "XTS", "CT6"].randomElement()!
        }
    }
}

struct Generator {
    static func generateVehicles(_ numberOfVehicles: Int) -> [Vehicle] {
        return (1...numberOfVehicles).lazy.map { _ in
            let make = Make.allCases.randomElement()!
            let vehicle = Vehicle(
                make: make.rawValue.capitalized,
                model: make.randomModel,
                year: Int.random(in: 1960...2018),
                id: UUID(),
                price: Int.random(in: 1_000...100_000)
            )
            return vehicle
        }
    }
}
