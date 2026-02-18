import Domain
import Persistence
import Testing
@testable import Results

struct FetchResultsUseCaseTests {

    @Test
    func `should_fetch_all_results`() async throws {
        let repository = mockRepository()
        let useCase = FetchResultsUseCase(repository: repository)

        _ = try await useCase.fetch(.all)

        #expect(await repository.kindsPassed == [.local, .remote])
    }

    @Test
    func `should_fetch_local_results`() async throws {
        let repository = mockRepository()
        let useCase = FetchResultsUseCase(repository: repository)

        _ = try await useCase.fetch(.local)

        #expect(await repository.kindsPassed == [.local])
    }

    @Test
    func `should_fetch_remote_results`() async throws {
        let repository = mockRepository()
        let useCase = FetchResultsUseCase(repository: repository)

        _ = try await useCase.fetch(.remote)

        #expect(await repository.kindsPassed == [.remote])
    }
}

// MARK: - Helpers & Factories

private func mockRepository() -> MockMatchResultsRepository {
    .init()
}

private final actor MockMatchResultsRepository: MatchResultsRepositoryType {
    var kindsPassed: Set<PersistenceKind> = []

    func fetch(_ kinds: Set<PersistenceKind>) async throws -> [MatchResult] {
        kindsPassed = kinds
        return []
    }

    func save(_ result: MatchResult) async throws {}
    func delete(_ result: MatchResult) async throws {}
}
