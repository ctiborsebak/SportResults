import Architecture
import FactoryKit
import Navigation
import SwiftUI

public struct ModalResultComposer: ComposingWithInput {

    public init() {}

    public func make(input: ModalResultInput) -> some View {
        let container = Container.shared

        let viewModel = container.modalResultViewModel.resolve(input)

        return ModalResultView(viewModel: viewModel)
    }
}
