import Firebase
import FirebaseFirestore
import Foundation

public struct MatchResultRemoteDto: Codable {

    @DocumentID var id: String?
    let discipline: DisciplineRemoteDto
    let name: String
    let location: String
    let date: Date
    let duurationInSeconds: Int
    let homeParticipant: ParticipantResultRemoteDto
    let awayParticipant: ParticipantResultRemoteDto
}

public enum DisciplineRemoteDto: String, Codable, Sendable {
    case basketball
    case soccer
    case tennis
}

public struct ParticipantResultRemoteDto: Codable {
    let name: String
    let score: Int
}

