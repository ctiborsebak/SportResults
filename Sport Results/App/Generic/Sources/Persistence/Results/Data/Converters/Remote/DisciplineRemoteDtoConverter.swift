import Domain
import ModelConverter

public struct DisciplineRemoteDtoConverter: ModelConvertible {
    public typealias DomainModel = Discipline
    public typealias ExternalModel = DisciplineRemoteDto

    public func toDomain(_ external: DisciplineRemoteDto) -> Discipline {
        switch external {

        case .basketball:
            return .basketball

        case .soccer:
            return .soccer

        case .tennis:
            return .tennis
        }
    }

    public func toExternal(_ domain: Discipline) -> DisciplineRemoteDto {
        switch domain {

        case .basketball:
            return .basketball

        case .soccer:
            return .soccer

        case .tennis:
            return .tennis
        }
    }
}
