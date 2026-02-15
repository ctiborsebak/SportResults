import Architecture
import FactoryKit
import Navigation
import SwiftUI

public struct AddResultComposer: Composing {

    public func make() -> some View {
        let container = Container.shared

        let viewModel = container.addResultViewModel.resolve()

        return AddResultView(viewModel: viewModel)
    }
}
