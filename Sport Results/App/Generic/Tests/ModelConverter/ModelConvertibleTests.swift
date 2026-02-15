import Testing
import Foundation
@testable import ModelConverter

struct ModelConvertibleTests {

    let sut = CatConverter()

    @Test
    func sut_should_result_in_identical_cat_when_round_tripped_through_dto() {
        let originalCat = Cat(name: "Bella", race: .maineCoon)

        let external = sut.toExternal(originalCat)
        let domain = sut.toDomain(external)

        #expect(originalCat.name == domain.name)
        #expect(originalCat.race == domain.race)
    }
}
