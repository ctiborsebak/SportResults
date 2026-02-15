import Domain
import Localizations

extension Discipline {
    var title: String {
        switch self {

        case .tennis:
            "key_picker_tennis".localized

        case .basketball:
            "key_picker_basketball".localized

        case .soccer:
            "key_picker_soccer".localized
        }
    }
}
