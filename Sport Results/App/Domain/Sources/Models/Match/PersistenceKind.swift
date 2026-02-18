public enum PersistenceKind: CaseIterable, Equatable, Identifiable, Sendable {
    case local
    case remote

    public var id: Self { self }
}
