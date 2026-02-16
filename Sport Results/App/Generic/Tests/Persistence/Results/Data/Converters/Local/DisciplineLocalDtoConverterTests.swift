import Domain
import Testing
@testable import Persistence

struct DisciplineLocalDtoConverterTests {

    let sut = DisciplineLocalDtoConverter()

    @Test(arguments: [
        (DisciplineLocalDto.basketball, Discipline.basketball),
        (DisciplineLocalDto.soccer, Discipline.soccer),
        (DisciplineLocalDto.tennis, Discipline.tennis)
    ])
    func sut_should_map_dto_to_domain_correctly(dto: DisciplineLocalDto, expected: Discipline) {
        let result = sut.toDomain(dto)

        #expect(result == expected)
    }

    @Test(arguments: [
        (Discipline.basketball, DisciplineLocalDto.basketball),
        (Discipline.soccer, DisciplineLocalDto.soccer),
        (Discipline.tennis, DisciplineLocalDto.tennis)
    ])
    func sut_should_map_domain_to_dto_correctly(domain: Discipline, expected: DisciplineLocalDto) {
        let result = sut.toExternal(domain)

        #expect(result == expected)
    }
}
