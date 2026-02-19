import Domain
import Foundation

struct AddResultInputState {
    var selectedDiscipline: Discipline = .soccer
    var matchName: String = ""
    var location: String = ""
    var date: Date = .now
    var hours: Int = 0
    var minutes: Int = 0
    var seconds: Int = 0
    var persistenceKind: PersistenceKind = .local
    var homeParticipantName: String = ""
    var homeParticipantScore: Int = 0
    var awayParticipantName: String = ""
    var awayParticipantScore: Int = 0

    var hasDurationChanged: Bool {
        !(hours == 0 && minutes == 0 && seconds == 0)
    }

    var didChange: Bool {
        let unchangedInput = AddResultInputState()

        return matchName != unchangedInput.matchName
        || location != unchangedInput.location
        || hasDurationChanged
        || homeParticipantName != unchangedInput.homeParticipantName
        || awayParticipantName != unchangedInput.awayParticipantName
    }

    var areMandatoryInputsFilled: Bool {
        !matchName.isEmpty
        && !location.isEmpty
        && hasDurationChanged
        && !homeParticipantName.isEmpty
        && !awayParticipantName.isEmpty
    }
}
