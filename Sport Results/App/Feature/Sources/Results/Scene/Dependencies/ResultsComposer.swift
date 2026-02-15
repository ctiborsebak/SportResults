import Architecture
import FactoryKit
import Navigation
import SwiftUI

public struct ResultsComposer: Composing {

    public init() {}

    public func make() -> some View {
        let container = Container.shared

        let viewFactory = container.resultsViewFactory.resolve()
        let viewModel = container.resultsViewModel.resolve()

        return NavigationContainer(factory: viewFactory) {
            ResultsView(viewModel: viewModel)
        }
    }
}
