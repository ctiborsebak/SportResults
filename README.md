# Project Title & Overview

Sport Results is an iOS demo application for creating, storing, and viewing sports match results. It demonstrates a modular Swift package-based architecture with clear separation between domain models, feature logic, shared infrastructure, UI theme/localization utilities, and data persistence providers (SwiftData for local storage and Firebase Firestore for remote storage).

## Basic principles
- Clean Architecture style layering: Domain (core models) -> Generic (shared infrastructure) -> Feature (business use cases + UI flows) -> App entry point.
- Feature-first modularization: each concern is split into dedicated Swift packages.
- Dependency Injection via Factory container modules/composers, while keeping ViewModels framework-agnostic.
- Navigation abstraction through a custom Navigator and NavigationContainer to avoid coupling navigation logic to feature ViewModels.
- Converter-based mapping between domain models and local/remote DTOs.

## Dependencies
### External
- Factory (hmlongco/Factory): dependency injection container.
- Firebase iOS SDK (Firestore): remote persistence.
### Apple Frameworks
- SwiftUI, Observation, Foundation.
- SwiftData (local persistence).
### Internal Swift Packages
- Domain: core models.
- Generic: architecture, navigation, persistence, modal utilities.
- Feature (Results product): app feature UI + use cases.
- Theme: UI components/colors/extensions.
- Localizations: localization helpers/resources.

## Thought process
A simple automated tests pipeline is in place, see <a href="https://github.com/ctiborsebak/SportResults/blob/develop/.github/workflows/tests.yml">tests.yml<a>

The project is setup by main component packages: App -> (Feature -> Generic) -> Domain. And utility packages: Localizations and Theme. Depenencies are resolved via Swift Package Manager. If we were to operate with a TabView, then perhaps another high level package would be a good practice. Such package would contain the tab view itself and its navigation stack wrapped tabs. This package would then depend on Feature and present individual feature flows.

Package structure follows Apple's Sources/Tests structure with Tests strictly mirroring Sources folder structure.

Even though available, we are omitting the use of <a href="https://github.com/hmlongco/Factory">Factory's</a> @Inject macro on purpose. This is because we would unnecessarily couple our ViewModels with said framework and that is not desired. Instead we moved dependency resolution into `<Component>Module.swift` and `<Component>Composer.swift` files, to make adjusting to a different DI framework, or ditching a DI framework all together more convenient. This way our tests are also DI framework-agnostic.

Same logic applies to navigation. ViewModels are 100% navigation framework agnostic. So if we swap our kinda crude `Navigator` and `NavigationContainer` to a different pattern (Flow, Router, Coordinator, etc.), we are provided with flexibility, that navigation-coupled ViewModels do not provide. A counter-point can be made that coupling VMs with navigation can result in better code coverage / testability.

In orthodox clean architecture all converters should have their own interfaces / protocols and strictly adhere to the D in SOLID. But since converters are usually pure functions (A to B) mocking them adds unnecessary boilerplate and maintenance overhead.

Since Firestore persists data locally and then synchronizes them with the server-side database upon successful Internet connection, there is no need to make the app function in 'Local' mode only when the user is offline, this is handled for us by the Firebase SDK.

## TODOs / Improvements
- Issues with native presentation animations when presenting multiple view variants over each other (modal over modal, alert over modal, etc.). These are now delayed by hardcoded values, but should be fixed on a conceptual level within `Navigation` target.
- Items are deleted by List's native swipe gesture. This might not be communicated clearly to the user, so an explicit delete button would be more user-friendly.

## Miscleanious
For more thought process and improvements see `// TODO:` and `// NOTE:` annotations within the project itself.
