import SwiftUI

public protocol Composing {
    associatedtype ComposedView: View

    @MainActor func make() -> ComposedView
}
