import SwiftUI
import Observation

private enum PreviewRoute: Hashable {
    case list
    case detail(id: String)
    case settings
    case profile
}

private struct HomeView: View {
    @Environment(Navigator.self) var navigator

    var body: some View {
        List {
            Section("Stack Navigation") {
                Button("Push List") {
                    navigator.navigate(to: PreviewRoute.list)
                }
                Button("Push Detail (Direct)") {
                    navigator.navigate(to: PreviewRoute.detail(id: "direct"))
                }
            }

            Section("Modals (Nested Flows)") {
                Button("Present Settings (Sheet)") {
                    navigator.presentModal(PreviewRoute.settings)
                }
                Button("Present Profile (Full Screen)") {
                    navigator.presentFullScreen(PreviewRoute.profile)
                }
            }
        }
        .navigationTitle("Home")
    }
}

private struct ListView: View {
    @Environment(Navigator.self) var navigator

    var body: some View {
        List(1...5, id: \.self) { i in
            Button("Item \(i)") {
                navigator.navigate(to: PreviewRoute.detail(id: "\(i)"))
            }
        }
        .navigationTitle("List")
    }
}

private struct DetailView: View {
    let id: String
    @Environment(Navigator.self) var navigator

    var body: some View {
        VStack(spacing: 20) {
            Text("Detail for ID: \(id)")
                .font(.title)

            Button("Pop") {
                navigator.pop()
            }

            Button("Pop to Root") {
                navigator.popToRoot()
            }

            if id.starts(with: "nested") {
                Button("Pop Modal (Parent)") {
                    print("Requesting parent dismissal")
                }
            }
        }
        .navigationTitle("Detail")
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
            Section("Settings") {
                Button("Account (Push)") {
                    navigator.navigate(to: PreviewRoute.detail(id: "nested-Account"))
                }
                Button("Privacy (Push)") {
                    navigator.navigate(to: PreviewRoute.detail(id: "nested-Privacy"))
                }
            }
        }
        .navigationTitle("Settings Flow")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Dismiss") {
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
            VStack(spacing: 20) {
                Text("Profile Flow (Full Screen)")
                    .font(.title)

                Button("Push Edit Profile") {
                    navigator.navigate(to: PreviewRoute.detail(id: "nested-EditProfile"))
                }

                Button("Push Security") {
                    navigator.navigate(to: PreviewRoute.detail(id: "nested-Security"))
                }

                Spacer()
            }
        }
        .navigationTitle("My Profile")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Close") {
                    navigator.dismiss()
                }
            }
        }
    }
}

private struct PreviewFactory: @MainActor ViewFactoryType {
    @MainActor @ViewBuilder
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
            }
        } else {
            Text("Unknown Route")
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
