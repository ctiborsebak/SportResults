import Foundation

public protocol Convertible {
    associatedtype DomainModel
    associatedtype ExternalModel
}

public protocol DomainConvertible: Convertible {
    func toDomain(_ external: ExternalModel) -> DomainModel
}

public protocol ExternalConvertible: Convertible {
    func toExternal(_ domain: DomainModel) -> ExternalModel
}

public typealias ModelConvertible = DomainConvertible & ExternalConvertible
