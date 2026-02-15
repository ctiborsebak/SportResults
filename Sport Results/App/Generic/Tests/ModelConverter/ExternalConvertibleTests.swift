import Testing
import Foundation
@testable import ModelConverter

struct ExternalConvertibleTests {

    let sut = CatConverter()

    @Test
    func sut_should_map_domain_model_to_dto_with_correct_raw_strings() {
        let cat = Cat(name: "Simba", race: .siamese)

        let dto = sut.toExternal(cat)

        #expect(dto.name == "Simba")
        #expect(dto.race == "siamese")
    }
}
