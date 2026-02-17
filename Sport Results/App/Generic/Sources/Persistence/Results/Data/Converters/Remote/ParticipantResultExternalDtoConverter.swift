import Domain
import ModelConverter

public struct ParticipantResultRemoteDtoConverter: ModelConvertible {
    public typealias DomainModel = ParticipantResult
    public typealias ExternalModel = ParticipantResultRemoteDto

    public func toDomain(_ external: ParticipantResultRemoteDto) -> ParticipantResult {
        ParticipantResult(
            name: external.name,
            score: external.score
        )
    }

    public func toExternal(_ domain: ParticipantResult) -> ParticipantResultRemoteDto {
        ParticipantResultRemoteDto(
            name: domain.name,
            score: domain.score
        )
    }
}
