import SwiftUI

public protocol Composing {
    associatedtype ComposedView: View

    @MainActor func make() -> ComposedView
}
public protocol ComposingWithInput {
    associatedtype Input
    associatedtype ComposedView: View

    @MainActor func make(input: Input) -> ComposedView
}
