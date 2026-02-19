import Domain
import Foundation
import Testing
@testable import Results // Adjust this to match your actual module name

struct AddResultInputStateConverterTests {

    let sut = AddResultInputStateConverter()

    @Test
    func sut_should_map_input_state_to_domain_correctly() throws {
        let input = AddResultInputState(
            selectedDiscipline: .basketball,
            matchName: "NBA Finals",
            location: "Boston TD Garden",
            date: Date(timeIntervalSince1970: 0),
            hours: 1,
            minutes: 30,
            seconds: 15,
            persistenceKind: .local,
            homeParticipantName: "Celtics",
            homeParticipantScore: 106,
            awayParticipantName: "Mavericks",
            awayParticipantScore: 99
        )

        let result = try sut.toDomain(input)

        #expect(result.discipline == .basketball)
        #expect(result.name == "NBA Finals")
        #expect(result.location == "Boston TD Garden")
        #expect(result.date == .init(timeIntervalSince1970: 0))
        #expect(result.duration == .seconds(5415))
        #expect(result.persistenceKind == .local)
        #expect(result.home.name == "Celtics")
        #expect(result.home.score == 106)
        #expect(result.away.name == "Mavericks")
        #expect(result.away.score == 99)
    }
}
