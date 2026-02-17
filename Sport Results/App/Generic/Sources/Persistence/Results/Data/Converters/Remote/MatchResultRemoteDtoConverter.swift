import Domain
import Foundation
import ModelConverter

public struct MatchResultRemoteDtoConverter: ModelConvertible {
    public typealias DomainModel = MatchResult
    public typealias ExternalModel = MatchResultRemoteDto

    private let disciplineRemoteDtoConverter: DisciplineRemoteDtoConverter
    private let participantResultRemoteDtoConverter: ParticipantResultRemoteDtoConverter

    public init(
        disciplineRemoteDtoConverter: DisciplineRemoteDtoConverter,
        participantResultRemoteDtoConverter: ParticipantResultRemoteDtoConverter
    ) {
        self.disciplineRemoteDtoConverter = disciplineRemoteDtoConverter
        self.participantResultRemoteDtoConverter = participantResultRemoteDtoConverter
    }

    public func toDomain(_ external: MatchResultRemoteDto) throws -> MatchResult {
        guard
            let externalId = external.id,
            let id = UUID(uuidString: externalId)
        else {
            throw MatchResultRemoteDtoConverterError.remoteIdMismatch
        }

        return MatchResult(
            id: id,
            discipline: disciplineRemoteDtoConverter.toDomain(external.discipline),
            name: external.name,
            location: external.location,
            date: external.date,
            duration: .seconds(external.duurationInSeconds),
            persistenceKind: .remote,
            home: participantResultRemoteDtoConverter.toDomain(external.homeParticipant),
            away: participantResultRemoteDtoConverter.toDomain(external.awayParticipant)
        )
    }

    public func toExternal(_ domain: MatchResult) -> MatchResultRemoteDto {
        MatchResultRemoteDto(
            id: domain.id.uuidString,
            discipline: disciplineRemoteDtoConverter.toExternal(domain.discipline),
            name: domain.name,
            location: domain.location,
            date: domain.date,
            duurationInSeconds: Int(domain.duration.components.seconds),
            homeParticipant: participantResultRemoteDtoConverter.toExternal(domain.home),
            awayParticipant: participantResultRemoteDtoConverter.toExternal(domain.away)
        )
    }
}

public enum MatchResultRemoteDtoConverterError: Error {
    case remoteIdMismatch
}
