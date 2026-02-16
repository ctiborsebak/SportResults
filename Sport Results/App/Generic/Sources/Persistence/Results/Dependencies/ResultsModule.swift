import Domain
import FactoryKit

extension Container {

    // MARK: - Converters

    var matchResultLocalDtoConverter: Factory<MatchResultLocalDtoConverter> {
        self {
            MatchResultLocalDtoConverter(
                disciplineLocalDtoConverter: self.disciplineLocalDtoConverter(),
                participantResultLocalDtoConverter: self.participantResultLocalDtoConverter()
            )
        }
    }

    var participantResultLocalDtoConverter: Factory<ParticipantResultLocalDtoConverter> {
        self { ParticipantResultLocalDtoConverter() }
    }

    var disciplineLocalDtoConverter: Factory<DisciplineLocalDtoConverter> {
        self { DisciplineLocalDtoConverter() }
    }

    // MARK: - Repositories

    var matchResultsLocalRepository: Factory<MatchResultsRepositoryType> {
        self {
            MatchResultsRepository(
                localStorageService: self.localResultsService(),
                // TODO: USE REMOTE SERVICE
                remoteStorageService: self.localResultsService()
            )
        }
        .singleton
    }

    // MARK: - Services

    var localResultsService: Factory<any DataServiceType<MatchResult>> {
        self {
            MatchResultsLocalService(
                container: self.sharedModelContainer(),
                converter: self.matchResultLocalDtoConverter()
            )
        }
        .singleton
    }
}
