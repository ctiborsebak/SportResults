import Domain
import Localizations
import ModalResult
import SwiftUI

@MainActor
@Observable
final class AddResultViewModel {

    @ObservationIgnored
    private let saveResultUseCase: SaveResultUseCaseType
    @ObservationIgnored
    private let addResultInputStateConverter: AddResultInputStateConverter

    init(
        saveResultUseCase: SaveResultUseCaseType,
        addResultInputStateConverter: AddResultInputStateConverter
    ) {
        self.saveResultUseCase = saveResultUseCase
        self.addResultInputStateConverter = addResultInputStateConverter
    }

    var inputState = AddResultInputState()
    var isLoading = false
    // NOTE: Apple Human Guidelines prefer clear, lightweight, contextual feedback, therefore an alert would be a better match here. But as error handling gets more complex (usually showing more descriptive feedback, version number etc. a modal would be better suited for such purpose. In this case I think modal is an overkill and an alert would do just fine. I wanted to "play" with the navigation a little more in depth, therefore we are presenting a modal result screen.
    var saveModalResult: ModalResultInput?
    var isPresentingProvideAllInputsAlert = false
    var isPresentingDiscardChangesAlert = false
    var isDismissing = false

    func save() async {
        guard inputState.areMandatoryInputsFilled else {
            isPresentingProvideAllInputsAlert = true
            return
        }

        defer { isLoading = false }
        isLoading = true

        do {
            let matchResult = try addResultInputStateConverter.toDomain(inputState)
            try await saveResultUseCase.save(matchResult)
            saveModalResult = successModalResultInput
        } catch {
            // NOTE: Edge case -> In case of instantinaious result we have to wait for the modal dismissal animation before presenting a new modal, else there can be unexpected behavior.
            try? await Task.sleep(for: .seconds(.modalDismissalDelay))
            saveModalResult = failureModalResultInput
        }
    }

    func discard() {
        guard !inputState.didChange else {
            isPresentingDiscardChangesAlert = true
            return
        }

        dismiss()
    }

    func resetSaveModal() {
        saveModalResult = nil
    }

    func hideAlert() {
        isPresentingProvideAllInputsAlert = false
        isPresentingDiscardChangesAlert = false
    }

    func dismiss() {
        Task {
            // TODO: Again, we need to delay the dismissal (wait for alert to pop) in order to preserve the nice native sheet dismissal animation. At this point, this logic should be revisited a bit and most likely solved inside Navigator / NavigationContainer itself.
            try? await Task.sleep(for: .seconds(.alertDismissDelay))
            isDismissing = true
        }
    }

    private var successModalResultInput: ModalResultInput {
        ModalResultInput(
            caption: "key_general_success".localized,
            kind: .success
        )
    }

    private var failureModalResultInput: ModalResultInput {
        ModalResultInput(
            caption: "key_general_error".localized,
            kind: .failure
        )
    }
}
