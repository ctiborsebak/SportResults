import FactoryKit

extension Container {
    var resultsViewFactory: Factory<ResultsViewFactory> {
        self { ResultsViewFactory() }
    }

    var resultsViewModel: Factory<ResultsViewModel> {
        self { ResultsViewModel() }
    }
}
