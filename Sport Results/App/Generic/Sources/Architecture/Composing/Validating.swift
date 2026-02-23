public protocol Validating {
    associatedtype Input
    associatedtype Output: ValidatorOutput

    func validate(_ input: Input) -> Output
}

public protocol ValidatorOutput {
    var isValid: Bool { get }
}
