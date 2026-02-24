import Testing
import Foundation
@testable import Navigation

@MainActor
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

        #expect(!dismissed)

        navigator.handlePresentationDismissCompletion()

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

        #expect(receivedResult == nil)

        navigator.handlePresentationDismissCompletion()

        let stringResult = receivedResult
        #expect(stringResult == "SavedValue")
    }

    @Test
    func navigator_should_invoke_nil_result_when_modal_is_dismissed_interactively() {
        let navigator = Navigator()
        var didDismiss = false
        var receivedResult: String? = "Sentinel"

        navigator.presentModalWithResult("Editor") { (result: String?) in
            didDismiss = true
            receivedResult = result
        }

        navigator.handleModalDismiss(at: 0)

        #expect(didDismiss)
        #expect(receivedResult == nil)
        #expect(navigator.presentedModals.isEmpty)
    }

    @Test
    func navigator_should_not_flush_deferred_modal_action_when_modal_dismiss_index_is_out_of_bounds() {
        let navigator = Navigator()
        var didDismiss = false

        navigator.presentModal("Settings") {
            didDismiss = true
        }

        navigator.dismissModal()
        navigator.handleModalDismiss(at: 0)

        #expect(!didDismiss)

        navigator.handlePresentationDismissCompletion()

        #expect(didDismiss)
    }

    @Test
    func navigator_should_flush_deferred_actions_one_by_one_in_fifo_order() {
        let navigator = Navigator()
        var receivedResults: [String] = []

        navigator.presentModalWithResult("First") { (result: String?) in
            if let result {
                receivedResults.append(result)
            }
        }
        navigator.dismissModal(returning: "FirstResult")

        navigator.presentModalWithResult("Second") { (result: String?) in
            if let result {
                receivedResults.append(result)
            }
        }
        navigator.dismissModal(returning: "SecondResult")

        #expect(receivedResults.isEmpty)

        navigator.handlePresentationDismissCompletion()
        #expect(receivedResults == ["FirstResult"])

        navigator.handlePresentationDismissCompletion()
        #expect(receivedResults == ["FirstResult", "SecondResult"])
    }

    @Test
    func navigator_should_defer_callbacks_for_stacked_modals_and_flush_on_each_dismiss_completion() {
        let navigator = Navigator()
        var receivedResults: [String] = []

        navigator.presentModalWithResult("First") { (result: String?) in
            if let result {
                receivedResults.append(result)
            }
        }
        navigator.presentModalWithResult("Second") { (result: String?) in
            if let result {
                receivedResults.append(result)
            }
        }

        #expect(navigator.presentedModals.count == 2)

        navigator.dismissModal(returning: "SecondResult")
        #expect(receivedResults.isEmpty)
        #expect(navigator.presentedModals.count == 1)

        navigator.handlePresentationDismissCompletion()
        #expect(receivedResults == ["SecondResult"])

        navigator.dismissModal(returning: "FirstResult")
        #expect(receivedResults == ["SecondResult"])
        #expect(navigator.presentedModals.isEmpty)

        navigator.handlePresentationDismissCompletion()
        #expect(receivedResults == ["SecondResult", "FirstResult"])
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
    func navigator_should_forward_result_when_dismissing_container() {
        let navigator = Navigator()
        var receivedResult: String?

        navigator.dismissClosure = { result in
            receivedResult = result as? String
        }

        navigator.dismiss(returning: "Success")

        #expect(receivedResult == "Success")
    }

    @Test
    func navigator_should_forward_nil_result_when_dismissing_container_without_result() {
        let navigator = Navigator()
        var didReceiveNilResult = false

        navigator.dismissClosure = { result in
            didReceiveNilResult = (result == nil)
        }

        navigator.dismiss()

        #expect(didReceiveNilResult)
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

    @Test
    func navigator_should_set_presented_alert_when_presenting() {
        let navigator = Navigator()
        let configuration = AlertConfiguration(title: "Test Alert")

        navigator.presentAlert(configuration: configuration)

        #expect(navigator.presentedAlert != nil)
        #expect(navigator.presentedAlert?.title == "Test Alert")
    }

    @Test
    func navigator_should_clear_presented_alert_when_dismissing() {
        let navigator = Navigator()
        let configuration = AlertConfiguration(title: "Test Alert")
        navigator.presentAlert(configuration: configuration)

        #expect(navigator.presentedAlert != nil)

        navigator.dismissAlert()

        #expect(navigator.presentedAlert == nil)
    }

    @Test
    func navigator_should_invoke_pending_alert_action_on_alert_dismiss() async {
        let navigator = Navigator()
        let configuration = AlertConfiguration(title: "Test Alert")
        var actionTriggered = false

        navigator.presentAlert(configuration: configuration)
        navigator.dismissAlert(perform: {
            actionTriggered = true
        })

        #expect(!actionTriggered)

        navigator.handleAlertDismiss()
        try? await Task.sleep(for: .seconds(0.12))

        #expect(actionTriggered)
    }
}
