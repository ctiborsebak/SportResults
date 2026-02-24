import FactoryKit
import Persistence

extension Container {

    // MARK: - View Factory

    var addResultViewFactory: Factory<AddResultViewFactory> {
        self { AddResultViewFactory() }
    }

    // MARK: - View Models

    var addResultViewModel: Factory<AddResultViewModel> {
        Factory(self) { @MainActor in
            AddResultViewModel(
                saveResultUseCase: self.saveResultUseCase(),
                addResultInputStateConverter: self.addResultInputStateConverter(),
                addResultInputStateValidator: self.addResultInputStateValidator()
            )
        }
    }

    // MARK: - Use Cases

    var saveResultUseCase: Factory<SaveResultUseCaseType> {
        self {
            SaveResultUseCase(
                repository: self.matchResultsRepository()
            )
        }
    }

    // MARK: - Converters

    var addResultInputStateConverter: Factory<AddResultInputStateConverter> {
        self { AddResultInputStateConverter() }
    }

    // MARK: - Validators

    var addResultInputStateValidator: Factory<AddResultInputStateValidator> {
        self { AddResultInputStateValidator() }
    }
}
