import SwiftUI

public protocol ViewFactoryType {
    associatedtype ResolvedView: View

    @MainActor @ViewBuilder func makeView(for destination: AnyHashable) -> ResolvedView
}
