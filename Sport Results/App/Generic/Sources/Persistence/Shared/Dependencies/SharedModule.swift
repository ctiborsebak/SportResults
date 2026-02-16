import FactoryKit
import SwiftData

extension Container {

    var sharedModelContainer: Factory<ModelContainer> {
        self {
            let schema = Schema([
                MatchResultLocalDto.self,
                ParticipantResultLocalDto.self
            ])

            let config = ModelConfiguration(isStoredInMemoryOnly: false)

            do {
                return try ModelContainer(for: schema, configurations: [config])
            } catch {
                fatalError("Failed to create ModelContainer: \(error)")
            }
        }
        .singleton
    }
}
