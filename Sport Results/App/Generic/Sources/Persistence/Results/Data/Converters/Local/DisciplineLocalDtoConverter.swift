import Domain
import ModelConverter

public struct DisciplineLocalDtoConverter: ModelConvertible {
    public typealias DomainModel = Discipline
    public typealias ExternalModel = DisciplineLocalDto

    public init() {}

    public func toDomain(_ external: DisciplineLocalDto) -> Discipline {
        switch external {

        case .basketball:
            return .basketball

        case .soccer:
            return .soccer

        case .tennis:
            return .tennis
        }
    }

    public func toExternal(_ domain: Discipline) -> DisciplineLocalDto {
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
