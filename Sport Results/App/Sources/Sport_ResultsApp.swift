import Results
import SwiftUI

@main
struct Sport_ResultsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ResultsComposer().make()
        }
    }
}
