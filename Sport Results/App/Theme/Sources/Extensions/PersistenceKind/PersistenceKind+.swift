import Domain
import SwiftUI

public extension PersistenceKind {
    var textColor: Color {
        switch self {

        case .local:
            return .Text.mint

        case .remote:
            return .Text.blue
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
