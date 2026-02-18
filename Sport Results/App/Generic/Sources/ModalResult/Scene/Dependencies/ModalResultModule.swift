import FactoryKit

extension Container {
    var modalResultViewModel: ParameterFactory<ModalResultInput, ModalResultViewModel> {
        ParameterFactory(self) { @MainActor input in
            ModalResultViewModel(input: input)
        }
    }
}
