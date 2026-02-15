import SwiftUI

@Observable
final public class ModalResultViewModel {

    let input: ModalResultInput

    public init(
        input: ModalResultInput
    ) {
        self.input = input
    }
}
