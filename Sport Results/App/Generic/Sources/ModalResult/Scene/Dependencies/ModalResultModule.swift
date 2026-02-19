import FactoryKit

extension Container {

    // MARK: - View Models

    var modalResultViewModel: ParameterFactory<ModalResultInput, ModalResultViewModel> {
        ParameterFactory(self) { @MainActor input in
            ModalResultViewModel(input: input)
        }
    }
}
