import Domain
import Localizations
import Persistence
import Testing
import Theme
@testable import ModalResult
@testable import Results

@MainActor
struct AddResultViewModelTests {

    // MARK: - Save Tests

    @Test
    func `save_should_show_alert_when_mandatory_inputs_are_missing`() async throws {
        let useCase = mockUseCase()
        let viewModel = makeViewModel(saveResultUseCase: useCase)

        await viewModel.save()

        #expect(viewModel.isPresentingProvideAllInputsAlert)

        let savedResult = await useCase.savedResult
        #expect(savedResult == nil)
    }

    @Test
    func `save_should_succeed_when_inputs_are_valid`() async throws {
        let useCase = mockUseCase()
        let viewModel = makeViewModel(saveResultUseCase: useCase)

        fillMandatoryInputs(for: &viewModel.inputState)

        await viewModel.save()

        #expect(viewModel.isLoading == false)
        #expect(viewModel.saveModalResult?.kind == .success)
        #expect(viewModel.saveModalResult?.caption == "key_general_success".localized)

        let savedResult = await useCase.savedResult
        #expect(savedResult != nil)
    }

    @Test
    func `save_should_show_error_modal`() async throws {
        let useCase = mockUseCase()
        await useCase.setError(TestError.simulated)

        let viewModel = makeViewModel(saveResultUseCase: useCase)

        fillMandatoryInputs(for: &viewModel.inputState)

        await viewModel.save()

        #expect(viewModel.isLoading == false)
        #expect(viewModel.saveModalResult?.kind == .failure)
        #expect(viewModel.saveModalResult?.caption == "key_general_error".localized)

        let savedResult = await useCase.savedResult
        #expect(savedResult == nil)
    }

    @Test
    func `discard_should_dismiss_when_no_changes_made`() async throws {
        let viewModel = makeViewModel()

        viewModel.discard()

        #expect(viewModel.isDismissing == true)
        #expect(!viewModel.isPresentingProvideAllInputsAlert)
    }

    @Test
    func `discard_should_show_alert_when_changes_made`() async throws {
        let viewModel = makeViewModel()

        simulateChanges(for: &viewModel.inputState)

        viewModel.discard()

        #expect(viewModel.isPresentingDiscardChangesAlert)
        #expect(viewModel.isDismissing == false)
    }

    @Test
    func `should_reset_save_modal`() async throws {
        let viewModel = makeViewModel()

        fillMandatoryInputs(for: &viewModel.inputState)
        await viewModel.save()
        #expect(viewModel.saveModalResult != nil)

        viewModel.resetSaveModal()

        #expect(viewModel.saveModalResult == nil)
    }

    @Test
    func `should_hide_alert`() async throws {
        let viewModel = makeViewModel()

        await viewModel.save()
        #expect(viewModel.isPresentingProvideAllInputsAlert)

        viewModel.hideAlert()

        #expect(!viewModel.isPresentingProvideAllInputsAlert)
    }
}

// MARK: - Helpers & Factories

@MainActor
private func makeViewModel(
    saveResultUseCase: SaveResultUseCaseType = mockUseCase(),
    addResultInputStateConverter: AddResultInputStateConverter = AddResultInputStateConverter(),
    addResultInputStateValidator: AddResultInputStateValidator = AddResultInputStateValidator()
) -> AddResultViewModel {
    .init(
        saveResultUseCase: saveResultUseCase,
        addResultInputStateConverter: addResultInputStateConverter,
        addResultInputStateValidator: addResultInputStateValidator
    )
}

private func mockUseCase() -> MockSaveResultUseCase {
    .init()
}

private func fillMandatoryInputs(for state: inout AddResultInputState) {
    state.matchName = "New Name"
    state.location = "New Location"
    state.seconds = 1
    state.homeParticipantName = "Home"
    state.awayParticipantName = "Away"
}

private func simulateChanges(for state: inout AddResultInputState) {
    state.matchName = "New Name"
}

private enum TestError: Error {
    case simulated
}

private final actor MockSaveResultUseCase: SaveResultUseCaseType {
    var savedResult: MatchResult?
    var errorStub: Error?

    func save(_ result: MatchResult) async throws {
        if let errorStub {
            throw errorStub
        }
        savedResult = result
    }

    func setError(_ error: Error) {
        self.errorStub = error
    }
}
