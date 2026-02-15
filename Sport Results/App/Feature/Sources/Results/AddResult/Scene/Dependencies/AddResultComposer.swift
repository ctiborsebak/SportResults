import Architecture
import FactoryKit
import Navigation
import SwiftUI

public struct AddResultComposer: Composing {

    public func make() -> some View {
        let container = Container.shared

        let viewFactory = container.addResultViewFactory.resolve()
        let viewModel = container.addResultViewModel.resolve()

        return NavigationContainer(factory: viewFactory) {
            AddResultView(viewModel: viewModel)
        }
    }
}
