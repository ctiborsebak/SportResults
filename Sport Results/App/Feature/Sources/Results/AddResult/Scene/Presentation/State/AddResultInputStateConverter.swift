import Domain
import Foundation
import ModelConverter

struct AddResultInputStateConverter: DomainConvertible {
    typealias DomainModel = MatchResult
    typealias ExternalModel = AddResultInputState

    func toDomain(_ external: AddResultInputState) throws -> MatchResult {
        MatchResult(
            discipline: external.selectedDiscipline,
            name: external.matchName,
            location: external.location,
            date: external.date,
            duration: .seconds(external.hours * 60 * 60 + external.minutes * 60 + external.seconds),
            persistenceKind: external.persistenceKind,
            home: .init(
                name: external.homeParticipantName,
                score: external.homeParticipantScore
            ),
            away: .init(
                name: external.awayParticipantName,
                score: external.awayParticipantScore
            )
        )
    }
}
