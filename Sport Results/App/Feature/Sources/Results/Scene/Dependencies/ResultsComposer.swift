import Architecture
import FactoryKit
import SwiftUI

@MainActor
public struct ResultsComposer: Composing {

    public init() {}

    public func make() -> some View {
        let container = Container.shared

        let viewModel = container.resultsViewModel.resolve()

        return ResultsView(viewModel: viewModel)
    }
}
