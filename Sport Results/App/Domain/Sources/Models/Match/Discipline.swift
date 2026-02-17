public enum Discipline: CaseIterable, Equatable, Identifiable, Sendable {
    case basketball
    case soccer
    case tennis

    public var id: Self { self }
}
