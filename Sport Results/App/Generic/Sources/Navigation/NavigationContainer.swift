import SwiftUI

public struct NavigationContainer<Factory: ViewFactoryType, Content: View>: View {
    @State var navigator: Navigator
    @Environment(\.dismiss) private var dismissAction

    private let factory: Factory
    private let dismissClosure: ((Any?) -> Void)?

    private let rootView: () -> Content

    public init(
        navigator: Navigator = Navigator(),
        dismissClosure: ((Any?) -> Void)? = nil,
        factory: Factory,
        @ViewBuilder rootView: @escaping () -> Content
    ) {
        self._navigator = State(initialValue: navigator)
        self.dismissClosure = dismissClosure
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
        .sheet(item: firstModalBinding) {
            navigator.handlePresentationDismissCompletion()
        } content: { modal in
            ModalStackView(
                navigator: navigator,
                factory: factory,
                modalIndex: 0
            )
        }
        .fullScreenCover(item: $navigator.presentedFullScreen) { destination in
            factory.makeView(for: destination)
        }
        .navigatorAlert()
        .environment(navigator)
        .onAppear {
            navigator.dismissClosure = { result in
                if let dismissClosure {
                    dismissClosure(result)
                } else {
                    dismissAction()
                }
            }
        }
        .onDisappear {
            navigator.dismissClosure = nil
        }
    }

    private var firstModalBinding: Binding<ModalDestination?> {
        Binding(
            get: { navigator.presentedModals.first },
            set: { newValue in
                if newValue == nil, !navigator.presentedModals.isEmpty {
                    navigator.handleModalDismiss(at: 0)
                }
            }
        )
    }
}
