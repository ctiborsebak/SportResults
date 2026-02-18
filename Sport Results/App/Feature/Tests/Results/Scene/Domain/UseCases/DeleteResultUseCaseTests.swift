import Domain
import Foundation
import Persistence
import Testing
@testable import Results

struct DeleteResultUseCaseTests {

    @Test
    func `should_delete_a_result`() async throws {
        let repository = mockRepository()
        let result = MatchResult.mock()
        let useCase = DeleteResultUseCase(repository: repository)

        _ = try await useCase.delete(result: result)

        #expect(await repository.matchPassed == result)
    }
}

// MARK: - Helpers & Factories

private func mockRepository() -> MockMatchResultsRepository {
    .init()
}

private final actor MockMatchResultsRepository: MatchResultsRepositoryType {
    var matchPassed: MatchResult?

    func delete(_ result: MatchResult) async throws {
        matchPassed = result
    }

    func fetch(_ kinds: Set<PersistenceKind>) async throws -> [MatchResult] { [] }
    func save(_ result: MatchResult) async throws {}
}
