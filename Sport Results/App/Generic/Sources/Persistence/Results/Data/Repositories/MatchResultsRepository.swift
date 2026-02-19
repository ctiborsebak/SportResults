import Domain

public final class MatchResultsRepository: MatchResultsRepositoryType {
    private let localStorageService: any DataServiceType<MatchResult>
    private let remoteStorageService: any DataServiceType<MatchResult>

    public init(
        localStorageService: any DataServiceType<MatchResult>,
        remoteStorageService: any DataServiceType<MatchResult>
    ) {
        self.localStorageService = localStorageService
        self.remoteStorageService = remoteStorageService
    }

    public func save(_ result: MatchResult) async throws {
        let service = service(for: result.persistenceKind)

        try await service.save(result)
    }

    public func delete(_ result: MatchResult) async throws {
        let service = service(for: result.persistenceKind)

        try await service.delete(id: result.id)
    }

    public func fetch(_ kinds: Set<PersistenceKind>) async throws -> [MatchResult] {
        try await withThrowingTaskGroup(of: [MatchResult].self) { group in
            kinds.forEach { kind in
                let service = service(for: kind)

                group.addTask {
                    try await service.fetchAll()
                }
            }

            return try await group.reduce(into: []) { result, partial in
                result.append(contentsOf: partial)
            }
        }
    }

    private func service(for kind: PersistenceKind) -> any DataServiceType<MatchResult> {
        switch kind {
        case .local:
            return localStorageService
        case .remote:
            return remoteStorageService
        }
    }
}
