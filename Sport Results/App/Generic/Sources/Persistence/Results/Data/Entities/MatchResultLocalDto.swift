import Foundation
import SwiftData

@Model
public final class MatchResultLocalDto {

    @Attribute(.unique) public var id: UUID

    var discipline: DisciplineLocalDto
    var name: String
    var location: String
    var date: Date
    var duration: TimeInterval
    @Relationship(deleteRule: .cascade)
    var home: ParticipantResultLocalDto
    @Relationship(deleteRule: .cascade)
    var away: ParticipantResultLocalDto

    init(
        id: UUID = UUID(),
        discipline: DisciplineLocalDto,
        name: String,
        location: String,
        date: Date,
        duration: TimeInterval,
        home: ParticipantResultLocalDto,
        away: ParticipantResultLocalDto
    ) {
        self.id = id
        self.discipline = discipline
        self.name = name
        self.location = location
        self.date = date
        self.duration = duration
        self.home = home
        self.away = away
    }
}

public enum DisciplineLocalDto: String, Codable, Sendable {
    case basketball
    case soccer
    case tennis
}

@Model
public final class ParticipantResultLocalDto {
    var name: String
    var score: Int

    public init(
        name: String,
        score: Int
    ) {
        self.name = name
        self.score = score
    }
}
