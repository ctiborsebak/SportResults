public enum PersistenceKind: CaseIterable, Identifiable, Sendable {
    case local
    case remote

    public var id: Self { self }
}
