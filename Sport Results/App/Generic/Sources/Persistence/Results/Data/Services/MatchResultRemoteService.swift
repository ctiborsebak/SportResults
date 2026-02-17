import Domain
import FirebaseFirestore
import Foundation

public actor MatchResultsRemoteService: DataServiceType {
    private let converter: MatchResultRemoteDtoConverter

    private let collectionName = "match_results"
    private let db = Firestore.firestore()

    public init(
        converter: MatchResultRemoteDtoConverter
    ) {
        self.converter = converter
    }

    public func save(_ item: MatchResult) async throws {
        let dto = converter.toExternal(item)

        guard let id = dto.id else {
            throw MatchResultRemoteServiceError.documentIdMismatch
        }

        try db.collection(collectionName)
            .document(id)
            .setData(from: dto)
    }

    public func delete(id: MatchResult.ID) async throws {
        try await db.collection(collectionName)
            .document(id.uuidString)
            .delete()
    }

    public func fetchAll() async throws -> [MatchResult] {
        let snapshot = try await db.collection(collectionName).getDocuments()

        return try snapshot.documents.compactMap { document in
            try? document.data(as: MatchResultRemoteDto.self)
        }
        .map(converter.toDomain)
    }
}

public enum MatchResultRemoteServiceError: Error {
    case documentIdMismatch
}
