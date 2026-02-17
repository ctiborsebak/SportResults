import Domain
import FactoryKit
import Foundation
import SwiftData
import Testing
@testable import Persistence

struct MatchResultsLocalServiceTests {

    @Test
    func should_save_match_result() async throws {
        let service = try makeService()
        let item = MatchResult.mock(id: UUID())

        try await service.save(item)

        let results = try await service.fetchAll()
        #expect(results.count == 1)
        #expect(results.first?.id == item.id)
    }

    @Test
    func should_return_empty_array_if_no_records_exist() async throws {
        let service = try makeService()

        let results = try await service.fetchAll()

        #expect(results.isEmpty)
    }

    @Test
    func should_fetch_all_records() async throws {
        let service = try makeService()
        let item1 = MatchResult.mock(id: UUID())
        let item2 = MatchResult.mock(id: UUID())

        try await service.save(item1)
        try await service.save(item2)

        let results = try await service.fetchAll()

        #expect(results.count == 2)
        #expect(results.contains { $0.id == item1.id })
        #expect(results.contains { $0.id == item2.id })
    }

    @Test
    func should_remove_item_with_correct_id() async throws {
        let service = try makeService()
        let targetID = UUID()
        let itemToDelete = MatchResult.mock(id: targetID)
        let itemToKeep = MatchResult.mock(id: UUID())

        try await service.save(itemToDelete)
        try await service.save(itemToKeep)

        try await service.delete(id: targetID)

        let results = try await service.fetchAll()
        #expect(results.count == 1)
        #expect(results.first?.id == itemToKeep.id)
        #expect(!results.contains { $0.id == targetID })
    }

    @Test
    func should_not_delete_anything_if_item_with_deletion_id_doesnt_exist() async throws {
        let service = try makeService()
        let existingItem = MatchResult.mock()
        try await service.save(existingItem)

        try await service.delete(id: UUID())

        let results = try await service.fetchAll()
        #expect(results.count == 1)
        #expect(results.first?.id == existingItem.id)
    }
}

// MARK: - Helpers & Factories

private func makeService() throws -> MatchResultsLocalService {
    let schema = Schema([
        MatchResultLocalDto.self,
        ParticipantResultLocalDto.self
    ])

    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try ModelContainer(for: schema, configurations: [config])

    let converter = MatchResultLocalDtoConverter(
        disciplineLocalDtoConverter: DisciplineLocalDtoConverter(),
        participantResultLocalDtoConverter: ParticipantResultLocalDtoConverter()
    )

    return MatchResultsLocalService(
        container: container,
        converter: converter
    )
}
