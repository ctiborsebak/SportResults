public struct ParticipantResult: Sendable {
    public let name: String
    public let score: Int

    public init(
        name: String,
        score: Int
    ) {
        self.name = name
        self.score = score
    }
}
