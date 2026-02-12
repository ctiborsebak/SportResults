import FactoryKit

extension Container {
    var resultsViewModel: Factory<ResultsViewModel> {
        self { ResultsViewModel() }
    }
}
