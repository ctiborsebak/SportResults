import Domain
import ModalResult
import SwiftUI

@MainActor
@Observable
final class ResultsViewModel {

    @ObservationIgnored
    private let fetchResultsUseCase: FetchResultsUseCaseType
    @ObservationIgnored
    private let deleteResultUseCase: DeleteResultUseCaseType

    init(
        fetchResultsUseCase: FetchResultsUseCaseType,
        deleteResultUseCase: DeleteResultUseCaseType
    ) {
        self.fetchResultsUseCase = fetchResultsUseCase
        self.deleteResultUseCase = deleteResultUseCase
    }

    var isLoading = false
    var isShowingError = false
    var filteredMatchResults: [MatchResult] = []
    var selectedFilter: MatchResultsFilter = .all
    var deleteModalResultInput: ModalResultInput?
    var failedDeletion: MatchResult?

    private var matchResults: [MatchResult] = []

    func changeFilter(_ filter: MatchResultsFilter) {
        selectedFilter = filter
        filterResults(by: filter)
    }

    func resetDeleteModal() {
        deleteModalResultInput = nil
    }

    func deleteResult(_ matchResult: MatchResult) async {
        defer { isLoading = false }
        isLoading = true

        do {
            failedDeletion = nil

            try await deleteResultUseCase.delete(result: matchResult)

            await fetchResults()
        } catch {
            failedDeletion = matchResult

            deleteModalResultInput = .init(
                caption: "key_general_error".localized,
                kind: .failure
            )

            await fetchResults()
        }
    }

    func fetchResults() async {
        isShowingError = false
        defer { isLoading = false }
        isLoading = true

         do {
             matchResults = try await fetchResultsUseCase.fetch(.all)
                 .sorted { $0.date > $1.date }

             filterResults(by: selectedFilter)
             
         } catch {
             // NOTE: Edge case -> In case of instantinaious result we have to wait for the modal dismissal animation before presenting a new modal, else there can be unexpected behavior.
             try? await Task.sleep(for: .seconds(.modalDismissalDelay))
             isShowingError = true
         }
    }

    private func filterResults(by filter: MatchResultsFilter) {
        filteredMatchResults = matchResults.filter { filter.persistenceKinds.contains($0.persistenceKind) }
    }
}
