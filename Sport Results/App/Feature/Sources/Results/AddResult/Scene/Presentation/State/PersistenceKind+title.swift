import Domain
import Localizations

extension PersistenceKind {
    var title: String {
        switch self {

        case .local:
            "key_filter_local".localized

        case .remote:
            "key_filter_remote".localized
        }
    }
}
