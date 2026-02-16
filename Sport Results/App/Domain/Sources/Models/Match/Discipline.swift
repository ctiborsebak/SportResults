public enum Discipline: CaseIterable, Identifiable, Sendable {
    case basketball
    case soccer
    case tennis

    public var id: Self { self }
}
