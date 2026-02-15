import Foundation
@testable import ModelConverter

struct CatDTO: Equatable {
    let name: String
    let race: String
}

struct Cat: Equatable {
    enum Race: String, Equatable, CaseIterable {
        case persian
        case siamese
        case maineCoon
        case mixed
    }
    let name: String
    let race: Race
}

struct CatConverter: ModelConvertible {
    typealias DomainModel = Cat
    typealias ExternalModel = CatDTO

    func toDomain(_ external: CatDTO) -> Cat {
        let race = Cat.Race(rawValue: external.race) ?? .mixed

        return Cat(
            name: external.name,
            race: race
        )
    }

    func toExternal(_ domain: Cat) -> CatDTO {
        return CatDTO(
            name: domain.name,
            race: domain.race.rawValue
        )
    }
}
