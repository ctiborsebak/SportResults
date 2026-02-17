import Domain
import Persistence

protocol FetchResultsUseCaseType {
    func fetch(_ filter: MatchResultsFilter) async throws -> [MatchResult]
}

final class FetchResultsUseCase: FetchResultsUseCaseType {

    private let repository: MatchResultsRepositoryType

    init(repository: MatchResultsRepositoryType) {
        self.repository = repository
    }

    func fetch(_ filter: MatchResultsFilter) async throws -> [MatchResult] {
        try await repository.fetch(filter.persistenceKinds)
    }
}

private extension MatchResultsFilter {
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
