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
}
