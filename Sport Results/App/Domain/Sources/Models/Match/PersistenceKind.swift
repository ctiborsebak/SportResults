public enum PersistenceKind: CaseIterable, Identifiable {
    case local
    case remote

    public var id: Self { self }
}
