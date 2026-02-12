import Foundation

public struct MatchResult {
    public let name: String
    public let location: String
    public let date: Date
    public let duration: TimeInterval
    public let persistenceKind: PersistenceKind
    public let homeTeam: TeamResult
    public let awayTeam: TeamResult

    public enum PersistenceKind {
        case local
        case remote
    }

    public struct TeamResult {
        public let teamName: String
        public let score: Int
    }
}
