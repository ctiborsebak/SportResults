import Domain
import Foundation
import ModelConverter

public struct MatchResultLocalDtoConverter: ModelConvertible {
    public typealias DomainModel = MatchResult
    public typealias ExternalModel = MatchResultLocalDto

    private let disciplineLocalDtoConverter: DisciplineLocalDtoConverter
    private let participantResultLocalDtoConverter: ParticipantResultLocalDtoConverter

    public init(
        disciplineLocalDtoConverter: DisciplineLocalDtoConverter,
        participantResultLocalDtoConverter: ParticipantResultLocalDtoConverter
    ) {
        self.disciplineLocalDtoConverter = disciplineLocalDtoConverter
        self.participantResultLocalDtoConverter = participantResultLocalDtoConverter
    }

    public func toDomain(_ external: MatchResultLocalDto) -> MatchResult {
        MatchResult(
            id: external.id,
            discipline: disciplineLocalDtoConverter.toDomain(external.discipline),
            name: external.name,
            location: external.location,
            date: external.date,
            duration: .seconds(external.duration),
            persistenceKind: .local,
            home: participantResultLocalDtoConverter.toDomain(external.home),
            away: participantResultLocalDtoConverter.toDomain(external.away)
        )
    }

    public func toExternal(_ domain: MatchResult) -> MatchResultLocalDto {
        MatchResultLocalDto(
            id: domain.id,
            discipline: disciplineLocalDtoConverter.toExternal(domain.discipline),
            name: domain.name,
            location: domain.location,
            date: domain.date,
            duration: TimeInterval(domain.duration.components.seconds),
            home: participantResultLocalDtoConverter.toExternal(domain.home),
            away: participantResultLocalDtoConverter.toExternal(domain.away)
        )
    }
}
