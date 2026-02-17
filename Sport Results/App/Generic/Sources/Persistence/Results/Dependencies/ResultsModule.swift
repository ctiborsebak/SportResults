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

    var matchResultRemoteDtoConverter: Factory<MatchResultRemoteDtoConverter> {
        self {
            MatchResultRemoteDtoConverter(
                disciplineRemoteDtoConverter: self.disciplineRemoteDtoConverter(),
                participantResultRemoteDtoConverter: self.participantResultRemoteDtoConverter()
            )
        }
    }

    var participantResultLocalDtoConverter: Factory<ParticipantResultLocalDtoConverter> {
        self { ParticipantResultLocalDtoConverter() }
    }

    var participantResultRemoteDtoConverter: Factory<ParticipantResultRemoteDtoConverter> {
        self { ParticipantResultRemoteDtoConverter() }
    }

    var disciplineLocalDtoConverter: Factory<DisciplineLocalDtoConverter> {
        self { DisciplineLocalDtoConverter() }
    }

    var disciplineRemoteDtoConverter: Factory<DisciplineRemoteDtoConverter> {
        self { DisciplineRemoteDtoConverter() }
    }

    // MARK: - Repositories

    var matchResultsLocalRepository: Factory<MatchResultsRepositoryType> {
        self {
            MatchResultsRepository(
                localStorageService: self.localResultsService(),
                remoteStorageService: self.remoteResultsService()
            )
        }
        .singleton
    }

    // MARK: - Services

    var remoteResultsService: Factory<any DataServiceType<MatchResult>> {
        self {
            MatchResultsRemoteService(
                converter: self.matchResultRemoteDtoConverter()
            )
        }
        .singleton
    }

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
