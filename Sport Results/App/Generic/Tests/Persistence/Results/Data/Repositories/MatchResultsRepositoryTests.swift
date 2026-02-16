import Domain
import Foundation
import Testing
@testable import Persistence

struct MatchResultsRepositoryTests {

    @Test
    func should_save_to_local_storage_when_kind_is_local() async throws {
        let localMock = MockDataService()
        let remoteMock = MockDataService()
        let repository = makeRepository(local: localMock, remote: remoteMock)

        let item = MatchResult.mock(id: UUID(), kind: .local)

        try await repository.save(item)

        let savedLocal = await localMock.savedItem
        let savedRemote = await remoteMock.savedItem

        #expect(savedLocal?.id == item.id)
        #expect(savedRemote == nil)
    }

    @Test
    func should_save_to_remote_storage_when_kind_is_remote() async throws {
        let localMock = MockDataService()
        let remoteMock = MockDataService()
        let repository = makeRepository(local: localMock, remote: remoteMock)

        let item = MatchResult.mock(id: UUID(), kind: .remote)

        try await repository.save(item)

        let savedLocal = await localMock.savedItem
        let savedRemote = await remoteMock.savedItem

        #expect(savedLocal == nil)
        #expect(savedRemote?.id == item.id)
    }

    @Test
    func should_throw_repository_error_when_save_fails() async throws {
        let localMock = MockDataService()
        let repository = makeRepository(local: localMock)
        let expectedError = TestError.generic
        await localMock.set(error: expectedError)

        try await confirmation { confirm in
            do {
                try await repository.save(.mock(kind: .local))
            } catch MatchResultsRepositoryError.local(let underlying) {
                #expect(underlying as? TestError == expectedError)
                confirm()
            }
        }
    }

    @Test
    func should_delete_from_correct_service_based_on_kind() async throws {
        let remoteMock = MockDataService()
        let repository = makeRepository(remote: remoteMock)

        let item = MatchResult.mock(id: UUID(), kind: .remote)

        try await repository.delete(item)

        let deletedID = await remoteMock.deletedID
        #expect(deletedID == item.id)
    }

    @Test
    func should_fetch_from_local_only() async throws {
        let localMock = MockDataService()
        let remoteMock = MockDataService()
        let repository = makeRepository(local: localMock, remote: remoteMock)

        let localItem = MatchResult.mock(kind: .local)
        await localMock.set(results: [localItem])

        let results = try await repository.fetch([.local])

        #expect(results.count == 1)
        #expect(results.first?.id == localItem.id)

        let remoteCalls = await remoteMock.fetchCallCount
        #expect(remoteCalls == 0)
    }

    @Test
    func should_aggregate_results_from_both_sources() async throws {
        let localMock = MockDataService()
        let remoteMock = MockDataService()
        let repository = makeRepository(local: localMock, remote: remoteMock)

        let item1 = MatchResult.mock(id: UUID(), kind: .local)
        let item2 = MatchResult.mock(id: UUID(), kind: .remote)

        await localMock.set(results: [item1])
        await remoteMock.set(results: [item2])

        let results = try await repository.fetch([.local, .remote])

        #expect(results.count == 2)
        #expect(results.contains { $0.id == item1.id })
        #expect(results.contains { $0.id == item2.id })
    }
}

// MARK: - Helpers & Factories

private func makeRepository(
    local: MockDataService = MockDataService(),
    remote: MockDataService = MockDataService()
) -> MatchResultsRepository {
    return MatchResultsRepository(
        localStorageService: local,
        remoteStorageService: remote
    )
}

private enum TestError: Error {
    case generic
}

actor MockDataService: DataServiceType {
    typealias Model = MatchResult

    var savedItem: MatchResult?
    var deletedID: UUID?
    var fetchCallCount: Int = 0

    private var resultsToReturn: [MatchResult] = []
    private var errorToThrow: Error?

    func set(results: [MatchResult]) {
        self.resultsToReturn = results
    }

    func set(error: Error?) {
        self.errorToThrow = error
    }

    func save(_ item: MatchResult) async throws {
        if let error = errorToThrow { throw error }
        self.savedItem = item
    }

    func delete(id: UUID) async throws {
        if let error = errorToThrow { throw error }
        self.deletedID = id
    }

    func fetchAll() async throws -> [MatchResult] {
        if let error = errorToThrow { throw error }
        fetchCallCount += 1
        return resultsToReturn
    }
}

private extension MatchResult {
    static func mock(id: UUID = UUID(), kind: PersistenceKind = .local) -> Self {
        .init(
            id: id,
            discipline: .soccer,
            name: "Mock Match",
            location: "Mock Location",
            date: Date(),
            duration: .seconds(60),
            persistenceKind: kind,
            home: ParticipantResult(name: "Home", score: 0),
            away: ParticipantResult(name: "Away", score: 0)
        )
    }
}
