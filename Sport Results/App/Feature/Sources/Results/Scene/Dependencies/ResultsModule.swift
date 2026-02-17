import FactoryKit

extension Container {

    // MARK: View Factory

    var resultsViewFactory: Factory<ResultsViewFactory> {
        self { ResultsViewFactory() }
    }

    // MARK: - View Models

    var resultsViewModel: Factory<ResultsViewModel> {
        self { ResultsViewModel() }
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
