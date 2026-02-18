import Domain

enum MatchResultsFilter {
    case all
    case local
    case remote
}

extension MatchResultsFilter {
    var persistenceKinds: Set<PersistenceKind> {
        switch self {

        case .all:
            [.local, .remote]

        case .local:
            [.local]

        case .remote:
            [.remote]
        }
    }
}
