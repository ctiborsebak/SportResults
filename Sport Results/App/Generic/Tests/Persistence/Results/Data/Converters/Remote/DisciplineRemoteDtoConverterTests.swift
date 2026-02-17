import Domain
import Testing
@testable import Persistence

struct DisciplineRemoteDtoConverterTests {

    let sut = DisciplineRemoteDtoConverter()

    @Test(arguments: [
        (DisciplineRemoteDto.basketball, Discipline.basketball),
        (DisciplineRemoteDto.soccer, Discipline.soccer),
        (DisciplineRemoteDto.tennis, Discipline.tennis)
    ])
    func sut_should_map_dto_to_domain_correctly(dto: DisciplineRemoteDto, expected: Discipline) {
        let result = sut.toDomain(dto)

        #expect(result == expected)
    }

    @Test(arguments: [
        (Discipline.basketball, DisciplineRemoteDto.basketball),
        (Discipline.soccer, DisciplineRemoteDto.soccer),
        (Discipline.tennis, DisciplineRemoteDto.tennis)
    ])
    func sut_should_map_domain_to_dto_correctly(domain: Discipline, expected: DisciplineRemoteDto) {
        let result = sut.toExternal(domain)

        #expect(result == expected)
    }
}
