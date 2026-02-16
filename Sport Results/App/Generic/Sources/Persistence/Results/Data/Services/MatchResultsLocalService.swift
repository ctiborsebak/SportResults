import Domain
import FactoryKit
import Foundation
import SwiftData

public actor MatchResultsLocalService: DataServiceType {

    private let container: ModelContainer
    private let converter: MatchResultLocalDtoConverter

    private let context: ModelContext

    public init(
        container: ModelContainer,
        converter: MatchResultLocalDtoConverter
    ) {
        self.container = container
        self.converter = converter
        self.context = ModelContext(container)
    }

    public func save(_ item: MatchResult) throws {
        let dto = converter.toExternal(item)
        context.insert(dto)

        try context.save()
    }

    public func delete(id: MatchResult.ID) throws {
        let predicate = #Predicate<MatchResultLocalDto> { $0.id == id }
        var descriptor = FetchDescriptor(predicate: predicate)
        descriptor.fetchLimit = 1

        if let item = try context.fetch(descriptor).first {
            context.delete(item)
            try context.save()
        }
    }

    public func fetchAll() throws -> [MatchResult] {
        let descriptor = FetchDescriptor<MatchResultLocalDto>()
        let dtos = try context.fetch(descriptor)

        return dtos.map(converter.toDomain(_:))
    }
}
