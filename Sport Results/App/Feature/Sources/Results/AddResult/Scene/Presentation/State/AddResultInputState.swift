import Domain
import Foundation

struct AddResultInputState: Equatable {
    var selectedDiscipline: Discipline = .basketball
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

    // TODO: Calendar should be injected as a dependency to improve testability, and as such a AddResultInputStateValidator object would be in place and used as a dependency in AddResultViewModel.
    var didChange: Bool {
        var unchangedInput = AddResultInputState()

        if Calendar.current.isDate(self.date, inSameDayAs: unchangedInput.date) {
            unchangedInput.date = self.date
        }

        return self != unchangedInput
    }
}
