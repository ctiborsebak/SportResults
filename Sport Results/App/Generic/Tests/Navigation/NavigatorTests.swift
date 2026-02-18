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
    func navigator_should_append_modal_when_presenting() {
        let navigator = Navigator()

        navigator.presentModal("Settings")

        #expect(navigator.presentedModals.count == 1)
        #expect(navigator.presentedModals.first?.destination == AnyHashable("Settings"))
    }

    @Test
    func navigator_should_present_modal_without_ondismiss() {
        let navigator = Navigator()

        navigator.presentModal("Settings")

        #expect(navigator.presentedModals.first?.onDismiss == nil)
    }

    @Test
    func navigator_should_remove_last_modal_when_dismissing() {
        let navigator = Navigator()
        navigator.presentModal("Settings")

        navigator.dismissModal()

        #expect(navigator.presentedModals.isEmpty)
    }

    @Test
    func navigator_should_invoke_ondismiss_when_dismissing() {
        let navigator = Navigator()
        var dismissed = false

        navigator.presentModal("Settings") {
            dismissed = true
        }

        navigator.dismissModal()

        #expect(dismissed)
    }

    @Test
    func navigator_should_pass_result_to_ondismiss() {
        let navigator = Navigator()
        var receivedResult: String?

        navigator.presentModalWithResult("Editor") { (result: String?) in
            receivedResult = result
        }

        navigator.dismissModal(returning: "SavedValue")

        let stringResult = receivedResult
        #expect(stringResult == "SavedValue")
    }

    @Test
    func navigator_should_stack_multiple_modals() {
        let navigator = Navigator()

        navigator.presentModal("First")
        navigator.presentModal("Second")

        #expect(navigator.presentedModals.count == 2)
        #expect(navigator.presentedModals[0].destination == AnyHashable("First"))
        #expect(navigator.presentedModals[1].destination == AnyHashable("Second"))
    }

    @Test
    func navigator_should_dismiss_only_topmost_modal() {
        let navigator = Navigator()
        navigator.presentModal("First")
        navigator.presentModal("Second")

        navigator.dismissModal()

        #expect(navigator.presentedModals.count == 1)
        #expect(navigator.presentedModals.first?.destination == AnyHashable("First"))
    }

    @Test
    func navigator_should_not_crash_when_dismissing_empty_modals() {
        let navigator = Navigator()

        navigator.dismissModal()

        #expect(navigator.presentedModals.isEmpty)
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
