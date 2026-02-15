import FactoryKit

extension Container {
    var addResultViewFactory: Factory<AddResultViewFactory> {
        self { AddResultViewFactory() }
    }

    var addResultViewModel: Factory<AddResultViewModel> {
        self { AddResultViewModel() }
    }
}
