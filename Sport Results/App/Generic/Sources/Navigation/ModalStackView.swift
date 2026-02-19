import SwiftUI

struct ModalStackView<Factory: ViewFactoryType>: View {
    let navigator: Navigator
    let factory: Factory
    let modalIndex: Int

    private var currentModal: ModalDestination? {
        guard modalIndex < navigator.presentedModals.count else { return nil }
        return navigator.presentedModals[modalIndex]
    }

    private var nextModalBinding: Binding<ModalDestination?> {
        let nextIndex = modalIndex + 1
        return Binding(
            get: {
                guard nextIndex < navigator.presentedModals.count else { return nil }
                return navigator.presentedModals[nextIndex]
            },
            set: { newValue in
                if newValue == nil, nextIndex < navigator.presentedModals.count {
                    navigator.handleModalDismiss(at: nextIndex)
                }
            }
        )
    }

    var body: some View {
        Group {
            if let modal = currentModal {
                factory.makeView(for: modal.destination)
            }
        }
        .sheet(item: nextModalBinding) {
            let nextIndex = modalIndex + 1
            navigator.handleModalDismiss(at: nextIndex)
        } content: { _ in
            ModalStackView(
                navigator: navigator,
                factory: factory,
                modalIndex: modalIndex + 1
            )
        }
        .alert(
            navigator.presentedAlert?.title ?? "",
            isPresented: Binding(
                get: {
                    let isTopModal = navigator.presentedModals.count - 1 == modalIndex
                    return navigator.presentedAlert != nil && isTopModal
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
    }
}
