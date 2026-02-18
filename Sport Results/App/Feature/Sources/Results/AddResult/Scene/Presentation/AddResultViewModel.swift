import Domain
import Localizations
import ModalResult
import SwiftUI

@MainActor
@Observable
final class AddResultViewModel {

    @ObservationIgnored
    private let saveResultUseCase: SaveResultUseCaseType

    init(
        saveResultUseCase: SaveResultUseCaseType,
    ) {
        self.saveResultUseCase = saveResultUseCase
    }

    var inputState = AddResultInputState()
    var isLoading = false
    var saveModalResult: ModalResultInput?

    func save() async {
        defer { isLoading = false }
        isLoading = true 

        do {
            try await saveResultUseCase.save(inputState.matchResult)
            saveModalResult = .init(
                caption: "key_general_success".localized,
                kind: .success
            )
        } catch {
            saveModalResult = .init(
                caption: "key_general_error".localized,
                kind: .failure
            )
        }
    }

    func resetSaveModal() {
        saveModalResult = nil
    }
}

private extension AddResultViewModel {
    enum RetryAction: Hashable {
        case addResult
    }
}

private extension AddResultInputState {
    var matchResult: MatchResult {
        .init(
            discipline: selectedDiscipline,
            name: matchName,
            location: location,
            date: date,
            duration: .seconds(hours * 60 * 60 + minutes * 60 + seconds),
            persistenceKind: persistenceKind,
            home: .init(
                name: homeParticipantName,
                score: homeParticipantScore
            ),
            away: .init(
                name: awayParticipantName,
                score: awayParticipantScore
            )
        )
    }
}
