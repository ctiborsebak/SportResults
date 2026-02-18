import Domain

public protocol MatchResultsRepositoryType: Sendable {
    func save(_ result: MatchResult) async throws
    func delete(_ result: MatchResult) async throws
    func fetch(_ kinds: Set<PersistenceKind>) async throws -> [MatchResult]
}
