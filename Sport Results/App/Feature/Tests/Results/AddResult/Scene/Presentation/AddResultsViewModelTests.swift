import Domain
import Localizations
import Persistence
import Testing
@testable import ModalResult
@testable import Results

@MainActor
struct AddResultViewModelTests {

    @Test
    func `should_save_result_successfully`() async throws {
        let useCase = mockUseCase()
        let viewModel = AddResultViewModel(saveResultUseCase: useCase)

        await viewModel.save()

        #expect(viewModel.isLoading == false)
        #expect(viewModel.saveModalResult?.kind == .success)
        #expect(viewModel.saveModalResult?.caption == "key_general_success".localized)

        let savedResult = await useCase.savedResult
        #expect(savedResult != nil)
    }

    @Test
    func `should_handle_save_error`() async throws {
        let useCase = mockUseCase()
        await useCase.setError(TestError.simulated)

        let viewModel = AddResultViewModel(saveResultUseCase: useCase)

        await viewModel.save()

        #expect(viewModel.isLoading == false)
        #expect(viewModel.saveModalResult?.kind == .failure)
        #expect(viewModel.saveModalResult?.caption == "key_general_error".localized)

        let savedResult = await useCase.savedResult
        #expect(savedResult == nil)
    }

    @Test
    func `should_reset_save_modal`() async throws {
        let useCase = mockUseCase()
        let viewModel = AddResultViewModel(saveResultUseCase: useCase)

        await viewModel.save()
        #expect(viewModel.saveModalResult != nil)

        viewModel.resetSaveModal()

        #expect(viewModel.saveModalResult == nil)
    }
}

// MARK: - Helpers & Factories

private func mockUseCase() -> MockSaveResultUseCase {
    .init()
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
