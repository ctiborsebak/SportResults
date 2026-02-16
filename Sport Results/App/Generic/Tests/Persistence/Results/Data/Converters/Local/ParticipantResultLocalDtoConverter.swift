import Testing
import Domain
@testable import Persistence

struct ParticipantResultLocalDtoConverterTests {

    let sut = ParticipantResultLocalDtoConverter()

    @Test
    func sut_should_map_dto_to_domain_correctly() {
        let dto = ParticipantResultLocalDto(name: "Lakers", score: 102)

        let result = sut.toDomain(dto)

        #expect(result.name == "Lakers")
        #expect(result.score == 102)
    }

    @Test
    func sut_should_map_domain_to_dto_correctly() {
        let domain = ParticipantResult(name: "Bulls", score: 98)

        let result = sut.toExternal(domain)

        #expect(result.name == "Bulls")
        #expect(result.score == 98)
    }
}
