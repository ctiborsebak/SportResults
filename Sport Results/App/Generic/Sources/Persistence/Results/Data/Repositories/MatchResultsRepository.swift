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

        do {
            try await service.save(result)
        } catch let error {
            throw result.persistenceKind.error(underlyingError: error)
        }
    }

    public func delete(_ result: MatchResult) async throws {
        let service = service(for: result.persistenceKind)

        do {
            try await service.delete(id: result.id)
        } catch let error {
            throw result.persistenceKind.error(underlyingError: error)
        }
    }

    public func fetch(_ kinds: Set<PersistenceKind>) async throws -> [MatchResult] {
        try await withThrowingTaskGroup(of: [MatchResult].self) { group in
            kinds.forEach { kind in
                let service = service(for: kind)

                group.addTask {
                    do {
                        return try await service.fetchAll()
                    } catch let error {
                        throw kind.error(underlyingError: error)
                    }
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

// NOTE: Errors should be more specific and propagated trough different layers (such as service can have a networking error, converter a conversion error etc.), these underlying errors then become much more traceable and "debuggable".
// Or they can be more generic such as AppError, RepositoryError etc, and these domain errors can be tied to specific captions / icons, etc.
enum MatchResultsRepositoryError: Error {
  case local(underlyingError: Error)
  case remote(underlyingError: Error)
}

private extension PersistenceKind {
    func error(underlyingError: Error) -> MatchResultsRepositoryError {
        switch self {
        case .local:
            return .local(underlyingError: underlyingError)
        case .remote:
            return .remote(underlyingError: underlyingError)
        }
    }
}
