import Domain
import ModelConverter

public struct ParticipantResultLocalDtoConverter: ModelConvertible {
    public typealias DomainModel = ParticipantResult
    public typealias ExternalModel = ParticipantResultLocalDto

    public init() {}

    public func toDomain(_ external: ParticipantResultLocalDto) -> ParticipantResult {
        ParticipantResult(
            name: external.name,
            score: external.score
        )
    }

    public func toExternal(_ domain: ParticipantResult) -> ParticipantResultLocalDto {
        ParticipantResultLocalDto(
            name: domain.name,
            score: domain.score
        )
    }
}
