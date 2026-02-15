public enum Discipline: CaseIterable, Identifiable {
    case basketball
    case soccer
    case tennis

    public var id: Self { self }
}
