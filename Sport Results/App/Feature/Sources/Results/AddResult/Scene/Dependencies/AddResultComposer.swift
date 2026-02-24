import Architecture
import FactoryKit
import Navigation
import SwiftUI

public struct AddResultComposer: Composing {

    public func make() -> some View {
        make(dismissClosure: nil)
    }

    @MainActor
    public func make(dismissClosure: ((Any?) -> Void)? = nil) -> some View {
        let container = Container.shared

        let viewFactory = container.addResultViewFactory.resolve()
        let viewModel = container.addResultViewModel.resolve()

        return NavigationContainer(
            dismissClosure: dismissClosure,
            factory: viewFactory
        ) {
            AddResultView(viewModel: viewModel)
        }
    }
}
