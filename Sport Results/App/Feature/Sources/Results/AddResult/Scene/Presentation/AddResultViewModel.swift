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
    @ObservationIgnored
    private let addResultInputStateValidator: AddResultInputStateValidator

    init(
        saveResultUseCase: SaveResultUseCaseType,
        addResultInputStateConverter: AddResultInputStateConverter,
        addResultInputStateValidator: AddResultInputStateValidator
    ) {
        self.saveResultUseCase = saveResultUseCase
        self.addResultInputStateConverter = addResultInputStateConverter
        self.addResultInputStateValidator = addResultInputStateValidator
    }

    var inputState = AddResultInputState()
    var isLoading = false
    // NOTE: Apple Human Guidelines prefer clear, lightweight, contextual feedback, therefore an alert would be a better match here. But as error handling gets more complex (usually showing more descriptive feedback, version number etc. a modal would be better suited for such purpose. In this case I think modal is an overkill and an alert would do just fine. I wanted to "play" with the navigation a little more in depth, therefore we are presenting a modal result screen.
    var saveModalResult: ModalResultInput?
    var isPresentingProvideAllInputsAlert = false
    var isPresentingDiscardChangesAlert = false
    var isDismissing = false
    var addResultValidatorOutput: AddResultInputStateValidatorOutput?

    func save() async {
        addResultValidatorOutput = addResultInputStateValidator.validate(inputState)

        guard addResultValidatorOutput?.isValid == true else {
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
        isDismissing = true
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
