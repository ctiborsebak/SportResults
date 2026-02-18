import Foundation

#if DEBUG
extension MatchResult {
    public static func mock(
        id: UUID = UUID(),
        discipline: Discipline = .soccer,
        name: String = "",
        location: String = "",
        date: Date = .init(),
        duration: Duration = .seconds(3600),
        persistenceKind: PersistenceKind = .local,
        home: ParticipantResult = .init(name: "", score: 0),
        away: ParticipantResult = .init(name: "", score: 0),
    ) -> MatchResult {
        .init(
            id: id,
            discipline: discipline,
            name: name,
            location: location,
            date: date,
            duration: duration,
            persistenceKind: persistenceKind,
            home: home,
            away: away
        )
    }
}
#endif
