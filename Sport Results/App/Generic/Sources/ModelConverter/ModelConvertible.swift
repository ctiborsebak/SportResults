import Foundation

public protocol Convertible {
    associatedtype DomainModel
    associatedtype ExternalModel
}

public protocol DomainConvertible: Convertible {
    func toDomain(_ external: ExternalModel) throws -> DomainModel
}

public protocol ExternalConvertible: Convertible {
    func toExternal(_ domain: DomainModel) throws -> ExternalModel
}

public typealias ModelConvertible = DomainConvertible & ExternalConvertible
