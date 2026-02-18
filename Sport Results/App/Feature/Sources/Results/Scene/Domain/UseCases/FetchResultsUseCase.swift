import Domain
import Foundation
import Persistence

protocol FetchResultsUseCaseType: Sendable {
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

#if DEBUG
final class PreviewFetchResultsUseCase: FetchResultsUseCaseType {
    init() {}

    func fetch(_ filter: MatchResultsFilter) async throws -> [MatchResult] {
        Array<MatchResult>(
            repeating: .init(
                discipline: .basketball,
                name: "Našinci",
                location: "Sokol Pisek",
                date: Date.now,
                duration: .seconds(48*60),
                persistenceKind: .local,
                home: .init(name: "Sršni Písek", score: 83),
                away: .init(name: "TJ Sokol Blatná", score: 32)
            ),
            count: 10
        )
    }
}
#endif
