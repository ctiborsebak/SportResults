import Domain
import SwiftUI
import Theme

extension PersistenceKind {
    var textColor: Color {
        switch self {

        case .local:
            return .Text.mint

        case .remote:
            return .Text.blue
        }
    }

    var accentColor: Color {
        switch self {

        case .local:
            return .Accent.mint

        case .remote:
            return .Accent.blue
        }
    }

    var icon: Image {
        switch self {

        case .local:
            return Image(systemName: "opticaldiscdrive.fill")

        case .remote:
            return Image(systemName: "checkmark.icloud.fill")
        }
    }
}
