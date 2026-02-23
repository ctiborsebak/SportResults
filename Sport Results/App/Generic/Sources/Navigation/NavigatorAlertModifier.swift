import SwiftUI

private struct NavigatorAlertModifier: ViewModifier {
    @Environment(Navigator.self) private var navigator: Navigator?
    let modalIndex: Int?

    func body(content: Content) -> some View {
        if let navigator {
            content.alert(
                navigator.presentedAlert?.title ?? "",
                isPresented: Binding(
                    get: {
                        isAlertPresented(for: navigator)
                    },
                    set: { isPresented in
                        if !isPresented {
                            navigator.dismissAlert()
                            navigator.handleAlertDismiss()
                        }
                    }
                ),
                presenting: navigator.presentedAlert
            ) { alert in
                ForEach(alert.actions) { action in
                    Button(action.title, role: action.role) {
                        navigator.dismissAlert(perform: action.action)
                    }
                }
            } message: { alert in
                if let message = alert.message {
                    Text(message)
                }
            }
        } else {
            content
        }
    }

    private func isAlertPresented(for navigator: Navigator) -> Bool {
        guard navigator.presentedAlert != nil else { return false }

        if let modalIndex {
            return navigator.presentedModals.count - 1 == modalIndex
        }

        return navigator.presentedModals.isEmpty
    }
}

extension View {
    func navigatorAlert(modalIndex: Int? = nil) -> some View {
        modifier(
            NavigatorAlertModifier(
                modalIndex: modalIndex
            )
        )
    }
}
