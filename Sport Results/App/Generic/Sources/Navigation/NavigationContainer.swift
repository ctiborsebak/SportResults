import SwiftUI
import Observation

public struct NavigationContainer<Factory: ViewFactoryType, Content: View>: View {
    @State var navigator: Navigator
    @Environment(\.dismiss) private var dismissAction

    private let factory: Factory

    private let rootView: () -> Content

    public init(
        navigator: Navigator = Navigator(),
        factory: Factory,
        @ViewBuilder rootView: @escaping () -> Content
    ) {
        self._navigator = State(initialValue: navigator)
        self.factory = factory
        self.rootView = rootView
    }

    public var body: some View {
        NavigationStack(path: $navigator.path) {
            rootView()
                .navigationDestination(for: AnyHashable.self) { destination in
                    factory.makeView(for: destination)
                }
        }
        .sheet(item: $navigator.presentedModal) { destination in
            factory.makeView(for: destination)
        }
        .fullScreenCover(item: $navigator.presentedFullScreen) { destination in
            factory.makeView(for: destination)
        }
        .environment(navigator)
        .onAppear {
            navigator.dismissClosure = {
                dismissAction()
            }
        }
    }
}
