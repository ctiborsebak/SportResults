import Domain
import Persistence

protocol SaveResultUseCaseType: Sendable {
    func save(_ result: MatchResult) async throws
}

final class SaveResultUseCase: SaveResultUseCaseType {

    private let repository: MatchResultsRepositoryType

    init(repository: MatchResultsRepositoryType) {
        self.repository = repository
    }

    func save(_ result: MatchResult) async throws {
        try await repository.save(result)
    }
}

#if DEBUG
final class PreviewSaveResultUseCase: SaveResultUseCaseType {
    func save(_ result: MatchResult) async throws { }
}
#endif
