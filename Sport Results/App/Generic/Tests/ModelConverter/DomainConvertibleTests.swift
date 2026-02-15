import Testing
import Foundation
@testable import ModelConverter

struct DomainConvertibleTests {

    let sut = CatConverter()

    @Test
    func sut_should_map_valid_dto_to_domain_model_correctly() {
        let dto = CatDTO(name: "Garfield", race: "persian")

        let cat = sut.toDomain(dto)

        #expect(cat.name == "Garfield")
        #expect(cat.race == .persian)
    }

    @Test
    func sut_should_default_to_mixed_race_when_dto_contains_unknown_race_string() {
        let dto = CatDTO(name: "Luna", race: "alien-cat")

        let cat = sut.toDomain(dto)

        #expect(cat.race == .mixed)
    }
}
