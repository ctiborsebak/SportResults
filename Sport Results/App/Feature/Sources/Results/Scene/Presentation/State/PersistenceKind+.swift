import Domain
import SwiftUI
import Theme

extension PersistenceKind {
    var accentColor: Color {
        switch self {

        case .local:
            return .Accent.mint

        case .remote:
            return .Accent.blue
        }
    }
}
