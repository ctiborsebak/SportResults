import Localizations
import ModalResult
import Navigation
import SwiftUI
import Theme

public struct ResultsView: View {

    @Environment(Navigator.self) var navigator: Navigator?
    @State var viewModel: ResultsViewModel

    public var body: some View {
        VStack(spacing: .medium) {
            filterPicker

            if viewModel.isLoading {
                ResultsLoadingView()
            } else if viewModel.isShowingError {
                errorView
            } else if viewModel.filteredMatchResults.isEmpty {
                noResultsView
            } else {
                resultList
            }
        }
        .padding(.vertical, .small)
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle("key_results_title".localized)
        .toolbar {
            ToolbarItem {
                addResultButton
            }
        }
        .task {
            await viewModel.fetchResults()
        }
        .onChange(of: viewModel.deleteModalResultInput) { _, newResult in
            handleDeleteResultModal(newResult)
        }
    }
}

private extension ResultsView {
    private var filterPicker: some View {
        let filterBinding = Binding<MatchResultsFilter>(
            get: { viewModel.selectedFilter },
            set: { viewModel.changeFilter($0) }
        )

        return Picker("", selection: filterBinding) {
            "key_filter_all".text.tag(MatchResultsFilter.all)
            "key_filter_local".text.tag(MatchResultsFilter.local)
            "key_filter_remote".text.tag(MatchResultsFilter.remote)
        }
        .pickerStyle(.segmented)
        .padding(.horizontal, .small)
    }

    private var addResultButton: some View {
        Button {
            navigator?.presentModalWithResult(ResultsRoute.addResult) { (action: AddResultAction?) in
                switch action {
                case .success:
                    Task {
                        await viewModel.fetchResults()
                    }
                default:
                    break
                }
            }
        } label: {
            Image(systemName: "plus")
                .padding(.xsmall)
        }
    }

    private var errorView: some View {
        ResultsErrorView(
            onRetry: {
                Task {
                    await viewModel.fetchResults()
                }
            }
        )
        .padding(.horizontal, .small)
    }

    private var noResultsView: some View {
        NoMatchResultsView(
            onSuccessfullAddition: {
                Task {
                    await viewModel.fetchResults()
                }
            }
        )
            .padding(.horizontal, .small)
    }

    private var resultList: some View {
        List(viewModel.filteredMatchResults) { result in
            MatchResultCard(state: result)
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        Task {
                            await viewModel.deleteResult(result)
                        }
                    } label: {
                        Image(systemName: "trash.fill")
                    }
                }
            // NOTE: The horizontal padding has to be applied to the items itself, not the whole List, otherwise the scroll indicator would be padded aswell -> missplaced
                .listRowInsets(EdgeInsets(top: .xsmall, leading: .small, bottom: .xsmall, trailing: .small))
                .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .refreshable {
            await viewModel.fetchResults()
        }
    }

    private func handleDeleteResultModal(_ input: ModalResultInput?) {
        guard let resultInput = input else { return }

        navigator?.presentModalWithResult(
            ResultsRoute.result(resultInput),
            onDismiss: { (action: ModalResultAction?) in
                viewModel.resetDeleteModal()

                switch action {
                case .retry:
                    guard let failedDeletion = viewModel.failedDeletion else { return }

                    Task {
                        // NOTE: Edge case -> In case of instantinaious result we have to wait for the modal dismissal animation, else there can be unexpected behavior.
                        try await Task.sleep(for: .seconds(.animationDelay))
                        await viewModel.deleteResult(failedDeletion)
                    }
                default:
                    break
                }
            }
        )
    }
}

#Preview("ResultsView") {
    let viewModel = ResultsViewModel(
        fetchResultsUseCase: PreviewFetchResultsUseCase(),
        deleteResultUseCase: PreviewDeleteResultUseCase()
    )

    return ResultsView(
        viewModel: viewModel
    )
}
