import Domain
import FirebaseFirestore
import Foundation

// NOTE: While MatchResultsLocalService gains a tangible benefit from being an `actor` (in the form of isolated ModelContainer), this remote service doesnt really benefit from it. But in my opinion its a good practice (no harm done) and easily expandable with a cache of the last result, for example. Once it evolves from stateless to stateful the actor starts bringing out its advantages.
public actor MatchResultsRemoteService: DataServiceType {
    private let converter: MatchResultRemoteDtoConverter

    // NOTE: It would be much better if every user had their own collection, preferably trough Firebase Auth. For demonstration purposes a shared collection will do.
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
            try document.data(as: MatchResultRemoteDto.self)
        }
        .map(converter.toDomain)
    }
}

public enum MatchResultRemoteServiceError: Error {
    case documentIdMismatch
    case typeMismatch
}
