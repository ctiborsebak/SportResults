import Testing
import SwiftUI
@testable import Navigation

struct ViewFactoryTypeTests {

    struct MockView: View {
        var body: some View { Text("Mock") }
    }

    struct MockFactory: ViewFactoryType {
        @ViewBuilder
        func makeView(for destination: AnyHashable) -> some View {
            if destination as? String == "Mock" {
                MockView()
            }
        }
    }

    @MainActor @Test
    func factory_should_resolve_view_for_known_destination() {
        let factory = MockFactory()

        let view = factory.makeView(for: "Mock")

        let description = String(reflecting: view)
        #expect(description.contains("MockView"))
        #expect(description.contains("trueContent"))
    }

    @MainActor @Test
    func factory_should_resolve_empty_view_for_unknown_destination() {
        let factory = MockFactory()

        let view = factory.makeView(for: "Unknown")

        let description = String(reflecting: view)
        #expect(!description.contains("trueContent"))
    }
}
