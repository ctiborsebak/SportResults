import SwiftUI
import Observation
import Theme

private enum PreviewRoute: Hashable {
    case list
    case detail(id: String)
    case settings
    case profile
    case modalB
    case modalC
}

private struct HomeView: View {
    @Environment(Navigator.self) var navigator
    @State private var lastResult: String?

    var body: some View {
        List {
            Section(String(localized: "Stack Navigation")) {
                Button(String(localized: "Push List")) {
                    navigator.navigate(to: PreviewRoute.list)
                }
                Button(String(localized: "Push Detail (Direct)")) {
                    navigator.navigate(to: PreviewRoute.detail(id: "direct"))
                }
            }

            Section(String(localized: "Modals (Nested Flows)")) {
                Button(String(localized: "Present Settings (Sheet)")) {
                    navigator.presentModal(PreviewRoute.settings)
                }
                Button(String(localized: "Present Profile (Full Screen)")) {
                    navigator.presentFullScreen(PreviewRoute.profile)
                }
            }

            Section(String(localized: "Stacked Modals Demo")) {
                Button(String(localized: "Present Modal A → B → C")) {
                    navigator.presentModal(PreviewRoute.modalB) { result in
                        if let value = result as? String {
                            lastResult = value
                        } else {
                            lastResult = String(localized: "Dismissed without result")
                        }
                    }
                }

                if let lastResult {
                    Text(String(localized: "Result from modal chain: \(lastResult)"))
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle(String(localized: "Home"))
    }
}

private struct ListView: View {
    @Environment(Navigator.self) var navigator

    var body: some View {
        List(1...5, id: \.self) { i in
            Button(String(localized: "Item \(i)")) {
                navigator.navigate(to: PreviewRoute.detail(id: "\(i)"))
            }
        }
        .navigationTitle(String(localized: "List"))
    }
}

private struct DetailView: View {
    let id: String
    @Environment(Navigator.self) var navigator

    var body: some View {
        VStack(spacing: .small) {
            Text(String(localized: "Detail for ID: \(id)"))
                .font(.title)

            Button(String(localized: "Pop")) {
                navigator.pop()
            }

            Button(String(localized: "Pop to Root")) {
                navigator.popToRoot()
            }
        }
        .navigationTitle(String(localized: "Detail"))
    }
}

private struct SettingsFlow: View {
    var body: some View {
        NavigationContainer(
            navigator: Navigator(),
            factory: PreviewFactory()
        ) {
            SettingsRootView()
        }
    }
}

private struct SettingsRootView: View {
    @Environment(Navigator.self) var navigator

    var body: some View {
        List {
            Section(String(localized: "Settings")) {
                Button(String(localized: "Account (Push)")) {
                    navigator.navigate(to: PreviewRoute.detail(id: "nested-Account"))
                }
                Button(String(localized: "Privacy (Push)")) {
                    navigator.navigate(to: PreviewRoute.detail(id: "nested-Privacy"))
                }
            }
        }
        .navigationTitle(String(localized: "Settings Flow"))
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(String(localized: "Dismiss")) {
                    navigator.dismiss()
                }
            }
        }
    }
}

private struct ProfileFlow: View {
    var body: some View {
        NavigationContainer(
            navigator: Navigator(),
            factory: PreviewFactory()
        ) {
            ProfileRootView()
        }
    }
}

private struct ProfileRootView: View {
    @Environment(Navigator.self) var navigator

    var body: some View {
        ZStack {
            Color(uiColor: .systemGroupedBackground).ignoresSafeArea()
            VStack(spacing: .small) {
                Text(String(localized: "Profile Flow (Full Screen)"))
                    .font(.title)

                Button(String(localized: "Push Edit Profile")) {
                    navigator.navigate(to: PreviewRoute.detail(id: "nested-EditProfile"))
                }

                Button(String(localized: "Push Security")) {
                    navigator.navigate(to: PreviewRoute.detail(id: "nested-Security"))
                }

                Spacer()
            }
        }
        .navigationTitle(String(localized: "My Profile"))
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(String(localized: "Close")) {
                    navigator.dismiss()
                }
            }
        }
    }
}

private struct ModalBView: View {
    @Environment(Navigator.self) var navigator
    @State private var resultFromC: String?

    var body: some View {
        NavigationStack {
            VStack(spacing: .medium) {
                Text(String(localized: "Modal B"))
                    .font(.largeTitle.bold())

                if let resultFromC {
                    Text(String(localized: "Received from C: \(resultFromC)"))
                        .foregroundStyle(.green)
                        .font(.headline)
                }

                Button(String(localized: "Present Modal C")) {
                    navigator.presentModal(PreviewRoute.modalC) { result in
                        if let value = result as? String {
                            resultFromC = value
                        }
                    }
                }
                .buttonStyle(.borderedProminent)

                Button(String(localized: "Dismiss with Result")) {
                    navigator.dismissModal(returning: resultFromC ?? "From B (no C result)")
                }
                .buttonStyle(.bordered)

                Button(String(localized: "Dismiss without Result")) {
                    navigator.dismissModal()
                }
                .foregroundStyle(.secondary)
            }
            .navigationTitle(String(localized: "Modal B"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

private struct ModalCView: View {
    @Environment(Navigator.self) var navigator

    var body: some View {
        NavigationStack {
            VStack(spacing: .medium) {
                Text(String(localized: "Modal C"))
                    .font(.largeTitle.bold())

                Text(String(localized: "Deepest modal in the stack"))
                    .foregroundStyle(.secondary)

                Button(String(localized: "Dismiss with Result")) {
                    navigator.dismissModal(returning: "Hello from C")
                }
                .buttonStyle(.borderedProminent)

                Button(String(localized: "Dismiss without Result")) {
                    navigator.dismissModal()
                }
                .foregroundStyle(.secondary)
            }
            .navigationTitle(String(localized: "Modal C"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

private struct PreviewFactory: ViewFactoryType {
    func makeView(for destination: AnyHashable) -> some View {
        if let route = destination as? PreviewRoute {
            switch route {
            case .list:
                ListView()
            case .detail(let id):
                DetailView(id: id)
            case .settings:
                SettingsFlow()
            case .profile:
                ProfileFlow()
            case .modalB:
                ModalBView()
            case .modalC:
                ModalCView()
            }
        } else {
            Text(String(localized: "Unknown Route"))
        }
    }
}

// MARK: - Previews

#Preview("Navigation Demo") {
    NavigationContainer(
        navigator: Navigator(),
        factory: PreviewFactory()
    ) {
        HomeView()
    }
}

#Preview("Deep Stack State") {
    let navigator = Navigator()
    navigator.path = [PreviewRoute.list, PreviewRoute.detail(id: "deep-link")]

    return NavigationContainer(
        navigator: navigator,
        factory: PreviewFactory()
    ) {
        HomeView()
    }
}
