import FactoryKit
import Persistence

extension Container {

    // MARK: - View Models

    var addResultViewModel: Factory<AddResultViewModel> {
        self { AddResultViewModel() }
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
