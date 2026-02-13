import Foundation

public struct MatchResult {
    public let discipline: Discipline
    public let name: String
    public let location: String
    public let date: Date
    public let duration: Duration
    public let persistenceKind: PersistenceKind
    public let home: ParticipantResult
    public let away: ParticipantResult

    public init(
        discipline: Discipline,
        name: String,
        location: String,
        date: Date,
        duration: Duration,
        persistenceKind: PersistenceKind,
        home: ParticipantResult,
        away: ParticipantResult
    ) {
        self.discipline = discipline
        self.name = name
        self.location = location
        self.date = date
        self.duration = duration
        self.persistenceKind = persistenceKind
        self.home = home
        self.away = away
    }
}
