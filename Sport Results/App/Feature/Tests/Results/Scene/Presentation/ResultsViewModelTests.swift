import Domain
import Foundation
import Localizations
import Persistence
import Testing
@testable import ModalResult
@testable import Results

@MainActor
struct ResultsViewModelTests {

    @Test
    func `should_fetch_and_sort_results_successfully`() async throws {
        let fetchUseCase = mockFetchUseCase()
        let deleteUseCase = mockDeleteUseCase()

        let date1 = Date(timeIntervalSince1970: 1)
        let date2 = Date(timeIntervalSince1970: 0)
        let result1 = MatchResult.mock(date: date1)
        let result2 = MatchResult.mock(date: date2)

        await fetchUseCase.setResults([result2, result1])

        let viewModel = ResultsViewModel(
            fetchResultsUseCase: fetchUseCase,
            deleteResultUseCase: deleteUseCase
        )

        await viewModel.fetchResults()

        #expect(viewModel.filteredMatchResults.count == 2)
        #expect(viewModel.filteredMatchResults[0].date == date1)
        #expect(viewModel.filteredMatchResults[1].date == date2)
    }

    @Test
    func `should_handle_fetch_error`() async throws {
        let fetchUseCase = mockFetchUseCase()
        let deleteUseCase = mockDeleteUseCase()

        await fetchUseCase.setError(TestError.simulated)

        let viewModel = ResultsViewModel(
            fetchResultsUseCase: fetchUseCase,
            deleteResultUseCase: deleteUseCase
        )

        await viewModel.fetchResults()

        #expect(viewModel.isShowingError == true)
    }

    @Test
    func `should_filter_results`() async throws {
        let fetchUseCase = mockFetchUseCase()
        let deleteUseCase = mockDeleteUseCase()

        let localResult = MatchResult.mock(persistenceKind: .local)
        let remoteResult = MatchResult.mock(persistenceKind: .remote)

        await fetchUseCase.setResults([localResult, remoteResult])

        let viewModel = ResultsViewModel(
            fetchResultsUseCase: fetchUseCase,
            deleteResultUseCase: deleteUseCase
        )

        await viewModel.fetchResults()
        #expect(viewModel.filteredMatchResults.count == 2)

        viewModel.changeFilter(.local)

        #expect(viewModel.selectedFilter == .local)
        #expect(viewModel.filteredMatchResults == [localResult])
    }

    @Test
    func `should_delete_result_successfully`() async throws {
        let fetchUseCase = mockFetchUseCase()
        let deleteUseCase = mockDeleteUseCase()

        let resultToDelete = MatchResult.mock()
        await fetchUseCase.setResults([resultToDelete])

        let viewModel = ResultsViewModel(
            fetchResultsUseCase: fetchUseCase,
            deleteResultUseCase: deleteUseCase
        )

        await viewModel.fetchResults()
        await viewModel.deleteResult(resultToDelete)

        let deleted = await deleteUseCase.deletedResult
        #expect(deleted?.id == resultToDelete.id)
        #expect(viewModel.failedDeletion == nil)
        #expect(viewModel.deleteModalResultInput == nil)
    }

    @Test
    func `should_handle_delete_error`() async throws {
        let fetchUseCase = mockFetchUseCase()
        let deleteUseCase = mockDeleteUseCase()

        let resultToDelete = MatchResult.mock()
        await deleteUseCase.setError(TestError.simulated)

        let viewModel = ResultsViewModel(
            fetchResultsUseCase: fetchUseCase,
            deleteResultUseCase: deleteUseCase
        )

        await viewModel.deleteResult(resultToDelete)

        #expect(viewModel.failedDeletion?.id == resultToDelete.id)
        #expect(viewModel.deleteModalResultInput?.kind == .failure)
        #expect(viewModel.deleteModalResultInput?.caption == "key_general_error".localized)
    }

    @Test
    func `should_reset_delete_modal`() async throws {
        let fetchUseCase = mockFetchUseCase()
        let deleteUseCase = mockDeleteUseCase()
        await deleteUseCase.setError(TestError.simulated)

        let viewModel = ResultsViewModel(
            fetchResultsUseCase: fetchUseCase,
            deleteResultUseCase: deleteUseCase
        )

        await viewModel.deleteResult(MatchResult.mock())
        #expect(viewModel.deleteModalResultInput != nil)

        viewModel.resetDeleteModal()

        #expect(viewModel.deleteModalResultInput == nil)
    }
}

// MARK: - Helpers & Factories

private func mockFetchUseCase() -> MockFetchResultsUseCase {
    .init()
}

private func mockDeleteUseCase() -> MockDeleteResultUseCase {
    .init()
}

private enum TestError: Error {
    case simulated
}

// MARK: - Mocks

private final actor MockFetchResultsUseCase: FetchResultsUseCaseType {
    var results: [MatchResult] = []
    var errorStub: Error?

    func fetch(_ filter: MatchResultsFilter) async throws -> [MatchResult] {
        if let errorStub {
            throw errorStub
        }
        return results
    }

    func setResults(_ results: [MatchResult]) {
        self.results = results
    }

    func setError(_ error: Error) {
        self.errorStub = error
    }
}

private final actor MockDeleteResultUseCase: DeleteResultUseCaseType {
    var deletedResult: MatchResult?
    var errorStub: Error?

    func delete(result: MatchResult) async throws {
        if let errorStub {
            throw errorStub
        }
        deletedResult = result
    }

    func setError(_ error: Error) {
        self.errorStub = error
    }
}
