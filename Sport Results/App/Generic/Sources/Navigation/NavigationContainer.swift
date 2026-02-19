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
        .sheet(item: firstModalBinding) {
            navigator.handleModalDismiss(at: 0)
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

        .alert(
            navigator.presentedAlert?.title ?? "",
            isPresented: Binding(
                get: {
                    navigator.presentedAlert != nil
                    && navigator.presentedModals.isEmpty
                },
                set: { isPresented in
                    if !isPresented { navigator.presentedAlert = nil }
                }
            ),
            presenting: navigator.presentedAlert
        ) { alert in
            ForEach(alert.actions) { action in
                Button(action.title, role: action.role) {
                    action.action?()
                }
            }
        } message: { alert in
            if let message = alert.message {
                Text(message)
            }
        }
        .environment(navigator)
        .onAppear {
            navigator.dismissClosure = {
                dismissAction()
            }
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
