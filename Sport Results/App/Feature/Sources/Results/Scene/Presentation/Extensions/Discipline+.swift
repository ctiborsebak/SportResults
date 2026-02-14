import Domain
import SwiftUI

extension Discipline {
    var icon: Image {
        switch self {

        case .tennis:
            return Image(systemName: "tennisball")

        case .basketball:
            return Image(systemName: "basketball")

        case .soccer:
            return Image(systemName: "soccerball")
        }
    }
}
