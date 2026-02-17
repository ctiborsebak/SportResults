import Domain
import Foundation
import Persistence
import Testing
@testable import Results

struct SaveResultUseCaseTests {

    @Test
    func `should_delete_a_result`() async throws {
        let repository = mockRepository()
        let result = MatchResult.mock()
        let useCase = SaveResultUseCase(repository: repository)

        _ = try await useCase.save(result)

        #expect(repository.matchPassed == result)
    }
}

// MARK: - Helpers & Factories

private func mockRepository() -> MockMatchResultsRepository {
    .init()
}

private class MockMatchResultsRepository: MatchResultsRepositoryType {
    var matchPassed: MatchResult?

    func save(_ result: MatchResult) async throws {
        matchPassed = result
    }

    func fetch(_ kinds: Set<PersistenceKind>) async throws -> [MatchResult] { [] }
    func delete(_ result: MatchResult) async throws {}
}
