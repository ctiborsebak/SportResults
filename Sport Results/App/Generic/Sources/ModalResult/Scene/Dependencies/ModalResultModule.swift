import FactoryKit

extension Container {
    var modalResultViewModel: ParameterFactory<ModalResultInput, ModalResultViewModel> {
        self { input in
            ModalResultViewModel(input: input)
        }
    }
}
