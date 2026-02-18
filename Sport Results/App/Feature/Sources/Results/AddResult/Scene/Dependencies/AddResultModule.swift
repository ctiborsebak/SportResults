import FactoryKit
import Persistence

extension Container {

    // MARK: - View Models

    var addResultViewModel: Factory<AddResultViewModel> {
        Factory(self) { @MainActor in
            AddResultViewModel(
                saveResultUseCase: self.saveResultUseCase()
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
}
