import FactoryKit

extension Container {

    // MARK: View Factory

    var resultsViewFactory: Factory<ResultsViewFactory> {
        self { ResultsViewFactory() }
    }

    // MARK: - View Models

    var resultsViewModel: Factory<ResultsViewModel> {
        Factory(self) { @MainActor in
            ResultsViewModel(
                fetchResultsUseCase: self.fetchResultsUseCase(),
                deleteResultUseCase: self.deleteResultsUseCase()
            )
        }
    }

    // MARK: - Use Cases

    var fetchResultsUseCase: Factory<FetchResultsUseCaseType> {
        self {
            FetchResultsUseCase(
                repository: self.matchResultsRepository()
            )
        }
    }

    var deleteResultsUseCase: Factory<DeleteResultUseCaseType> {
        self {
            DeleteResultUseCase(
                repository: self.matchResultsRepository()
            )
        }
    }
}
