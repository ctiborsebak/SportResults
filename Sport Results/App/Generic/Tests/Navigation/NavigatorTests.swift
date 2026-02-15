import Testing
import Foundation
@testable import Navigation

struct NavigatorTests {

    @Test
    func navigator_should_update_path_when_navigating_to_destination() {
        let navigator = Navigator()
        let destination = "Profile"

        navigator.navigate(to: destination)

        #expect(navigator.path.count == 1)
        #expect(navigator.path.last == AnyHashable(destination))
    }

    @Test
    func navigator_should_remove_last_element_when_popping() {
        let navigator = Navigator()
        navigator.navigate(to: "Screen1")
        navigator.navigate(to: "Screen2")

        navigator.pop()

        #expect(navigator.path.count == 1)
        #expect(navigator.path.last == AnyHashable("Screen1"))
    }

    @Test
    func navigator_should_clear_path_when_popping_to_root() {
        let navigator = Navigator()
        navigator.navigate(to: "Screen1")
        navigator.navigate(to: "Screen2")

        navigator.popToRoot()

        #expect(navigator.path.isEmpty)
    }

    @Test
    func navigator_should_pop_to_specific_destination() {
        let navigator = Navigator()
        navigator.navigate(to: "Screen1")
        navigator.navigate(to: "Screen2")
        navigator.navigate(to: "Screen3")

        navigator.popTo("Screen1")

        #expect(navigator.path.count == 1)
        #expect(navigator.path.last == AnyHashable("Screen1"))
    }

    @Test
    func navigator_should_update_modal_when_presenting_modal() {
        let navigator = Navigator()
        let destination = "Settings"

        navigator.presentModal(destination)

        #expect(navigator.presentedModal == AnyHashable(destination))
    }

    @Test
    func navigator_should_clear_modal_when_dismissing() {
        let navigator = Navigator()
        navigator.presentModal("Settings")

        navigator.dismissModal()

        #expect(navigator.presentedModal == nil)
    }

    @Test
    func navigator_should_update_full_screen_when_presenting_full_screen() {
        let navigator = Navigator()
        let destination = "Login"

        navigator.presentFullScreen(destination)

        #expect(navigator.presentedFullScreen == AnyHashable(destination))
    }

    @Test
    func navigator_should_do_nothing_when_popping_empty_path() {
        let navigator = Navigator()

        navigator.pop()

        #expect(navigator.path.isEmpty)
    }

    @Test
    func not_found_destination_should_not_change_path() {
        let navigator = Navigator()
        navigator.navigate(to: "Screen1")

        navigator.popTo("Unknown")

        #expect(navigator.path.count == 1)
        #expect(navigator.path.last == AnyHashable("Screen1"))
    }
}
