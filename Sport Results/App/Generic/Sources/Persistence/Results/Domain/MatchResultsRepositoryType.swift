import Domain

public protocol MatchResultsRepositoryType {
    func save(_ result: MatchResult) async throws
    func delete(_ result: MatchResult) async throws
    func fetch(_ kinds: Set<PersistenceKind>) async throws -> [MatchResult]
}
