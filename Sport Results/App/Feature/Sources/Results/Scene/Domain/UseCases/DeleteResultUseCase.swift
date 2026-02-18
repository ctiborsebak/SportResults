import Domain
import Persistence

protocol DeleteResultUseCaseType: Sendable {
    func delete(result: MatchResult) async throws
}

final class DeleteResultUseCase: DeleteResultUseCaseType {

    private let repository: MatchResultsRepositoryType

    init(repository: MatchResultsRepositoryType) {
        self.repository = repository
    }

    func delete(result: MatchResult) async throws {
        try await repository.delete(result)
    }
}

#if DEBUG
final class PreviewDeleteResultUseCase: DeleteResultUseCaseType {
    func delete(result: MatchResult) async throws {}
}
#endif
