import Domain
import Foundation
import Testing
@testable import Persistence

struct MatchResultRemoteDtoConverterTests {

    let sut = MatchResultRemoteDtoConverter(
        disciplineRemoteDtoConverter: DisciplineRemoteDtoConverter(),
        participantResultRemoteDtoConverter: ParticipantResultRemoteDtoConverter()
    )

    @Test
    func sut_should_map_dto_to_domain_correctly() throws {
        let date = Date(timeIntervalSince1970: 1000)
        let dto = MatchResultRemoteDto(
            id: "26929514-237c-11ed-861d-0242ac120002",
            discipline: .soccer,
            name: "Champions League Final",
            location: "Paris",
            date: date,
            duurationInSeconds: 5400,
            homeParticipant: ParticipantResultRemoteDto(name: "Liverpool", score: 2),
            awayParticipant: ParticipantResultRemoteDto(name: "Real Madrid", score: 1)
        )

        let result = try sut.toDomain(dto)

        #expect(result.id == UUID(uuidString: "26929514-237c-11ed-861d-0242ac120002"))
        #expect(result.discipline == .soccer)
        #expect(result.name == "Champions League Final")
        #expect(result.location == "Paris")
        #expect(result.date == date)
        #expect(result.duration == .seconds(5400))
        #expect(result.persistenceKind == .remote)
        #expect(result.home.name == "Liverpool")
        #expect(result.away.score == 1)
    }

    @Test
    func sut_should_throw_error_when_remote_id_is_invalid() {
        let dto = MatchResultRemoteDto(
            id: "invalid-uuid-string",
            discipline: .soccer,
            name: "Test Match",
            location: "Nowhere",
            date: Date(),
            duurationInSeconds: 0,
            homeParticipant: ParticipantResultRemoteDto(name: "A", score: 0),
            awayParticipant: ParticipantResultRemoteDto(name: "B", score: 0)
        )

        #expect(throws: MatchResultRemoteDtoConverterError.remoteIdMismatch) {
            try sut.toDomain(dto)
        }
    }

    @Test
    func sut_should_throw_error_when_remote_id_is_nil() {
        let dto = MatchResultRemoteDto(
            id: nil,
            discipline: .soccer,
            name: "Test Match",
            location: "Nowhere",
            date: Date(),
            duurationInSeconds: 0,
            homeParticipant: ParticipantResultRemoteDto(name: "A", score: 0),
            awayParticipant: ParticipantResultRemoteDto(name: "B", score: 0)
        )

        #expect(throws: MatchResultRemoteDtoConverterError.remoteIdMismatch) {
            try sut.toDomain(dto)
        }
    }

    @Test
    func sut_should_map_domain_to_dto_correctly() {
        let date = Date(timeIntervalSince1970: 2000)
        let domain = MatchResult(
            id: UUID(uuidString: "26929514-237C-11ED-861D-0242AC120002")!,
            discipline: .tennis,
            name: "Wimbledon",
            location: "London",
            date: date,
            duration: .seconds(7200),
            persistenceKind: .remote,
            home: ParticipantResult(name: "Federer", score: 3),
            away: ParticipantResult(name: "Nadal", score: 2)
        )

        let result = sut.toExternal(domain)

        #expect(result.id == "26929514-237C-11ED-861D-0242AC120002")
        #expect(result.discipline == .tennis)
        #expect(result.name == "Wimbledon")
        #expect(result.location == "London")
        #expect(result.date == date)
        #expect(result.duurationInSeconds == 7200)
        #expect(result.homeParticipant.name == "Federer")
        #expect(result.homeParticipant.score == 3)
        #expect(result.awayParticipant.name == "Nadal")
        #expect(result.awayParticipant.score == 2)
    }
}
