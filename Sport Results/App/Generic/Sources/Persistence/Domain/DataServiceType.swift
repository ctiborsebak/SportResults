import Foundation

public protocol DataServiceType<Model>: Actor {
    associatedtype Model: Identifiable

    func save(_ item: Model) async throws
    func delete(id: Model.ID) async throws
    func fetchAll() async throws -> [Model]
}
