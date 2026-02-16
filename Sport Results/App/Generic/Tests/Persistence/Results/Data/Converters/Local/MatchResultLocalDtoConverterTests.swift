import Domain
import Foundation
import Testing
@testable import Persistence

struct MatchResultLocalDtoConverterTests {

    let sut = MatchResultLocalDtoConverter(
        disciplineLocalDtoConverter: DisciplineLocalDtoConverter(),
        participantResultLocalDtoConverter: ParticipantResultLocalDtoConverter()
    )

    @Test
    func sut_should_map_dto_to_domain_correctly() {
        let date = Date(timeIntervalSince1970: 0)
        let dto = MatchResultLocalDto(
            id: UUID(uuidString: "26929514-237c-11ed-861d-0242ac120002")!,
            discipline: .soccer,
            name: "Champions League Final",
            location: "Paris",
            date: date,
            duration: TimeInterval(5400),
            home: ParticipantResultLocalDto(name: "Liverpool", score: 2),
            away: ParticipantResultLocalDto(name: "Real Madrid", score: 1)
        )

        let result = sut.toDomain(dto)

        #expect(result.id == UUID(uuidString: "26929514-237c-11ed-861d-0242ac120002"))
        #expect(result.discipline == .soccer)
        #expect(result.name == "Champions League Final")
        #expect(result.location == "Paris")
        #expect(result.date == date)
        #expect(result.duration == .seconds(5400))
        #expect(result.persistenceKind == .local)
        #expect(result.home.name == "Liverpool")
        #expect(result.away.score == 1)
    }

    @Test
    func sut_should_map_domain_to_dto_correctly() {
        let date = Date(timeIntervalSince1970: 0)
        let domain = MatchResult(
            id: UUID(uuidString: "26929514-237c-11ed-861d-0242ac120002")!,
            discipline: .tennis,
            name: "Wimbledon",
            location: "London",
            date: date,
            duration: .seconds(7200),
            persistenceKind: .local,
            home: ParticipantResult(name: "Federer", score: 3),
            away: ParticipantResult(name: "Nadal", score: 2)
        )

        let result = sut.toExternal(domain)

        #expect(result.id == UUID(uuidString: "26929514-237c-11ed-861d-0242ac120002"))
        #expect(result.discipline == .tennis)
        #expect(result.name == "Wimbledon")
        #expect(result.location == "London")
        #expect(result.duration == TimeInterval(7200))
        #expect(result.home.name == "Federer")
        #expect(result.home.score == 3)
        #expect(result.away.name == "Nadal")
        #expect(result.away.score == 2)
    }
}
