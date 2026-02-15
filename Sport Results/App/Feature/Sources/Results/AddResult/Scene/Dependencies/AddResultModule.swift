import FactoryKit

extension Container {
    var addResultViewModel: Factory<AddResultViewModel> {
        self { AddResultViewModel() }
    }
}
