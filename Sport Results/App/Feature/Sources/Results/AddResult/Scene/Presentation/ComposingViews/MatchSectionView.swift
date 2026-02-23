import Domain
import SwiftUI
import Theme

struct MatchSectionView: View {
    @Binding var inputState: AddResultInputState
    var homeTeamNamePlaceholderColor = Color.Text.tertiary
    var awayTeamNamePlaceholderColor = Color.Text.tertiary
    var durationTitleColor = Color.Text.primary

    init(
        inputState: Binding<AddResultInputState>,
        inputStateValidatorOuput: AddResultInputStateValidatorOutput?
    ) {
        self._inputState = inputState

        guard let inputStateValidatorOuput else { return }
        homeTeamNamePlaceholderColor = inputStateValidatorOuput.isHomeParticipantNameValid ? .Text.tertiary : .Semantic.error
        awayTeamNamePlaceholderColor = inputStateValidatorOuput.isAwayParticipantNameValid ? .Text.tertiary : .Semantic.error
        durationTitleColor = inputState.wrappedValue.hasDurationChanged ? .Text.primary : .Semantic.error
    }

    var body: some View {
        VStack(alignment: .leading, spacing: .small) {
            sectionTitle

            Card {
                VStack(spacing: .small) {
                    durationPicker

                    Divider()

                    VStack(spacing: .small) {
                        HStack {
                            homeTeamNameInputField

                            Spacer()

                            awayTeamNameInputField
                        }

                        scoreInputFields
                    }
                }
            }
        }
        .textFieldStyle(.roundedBorder)
    }

    private var sectionTitle: some View {
        "key_section_match_information".localized
            .text
            .foregroundStyle(Color.Text.primary)
            .font(.title3)
            .fontWeight(.medium)
    }

    private var durationPicker: some View {
        HStack {
            "key_duration".localized
                .text
                .foregroundStyle(durationTitleColor)

            Spacer()

            Group {
                Picker("", selection: $inputState.hours) {
                    ForEach(0..<10) { Text("\($0) h").tag($0) }
                }

                Picker("", selection: $inputState.minutes) {
                    ForEach(0..<60) { Text("\($0) m").tag($0) }
                }

                Picker("", selection: $inputState.seconds) {
                    ForEach(0..<60) { Text("\($0) s").tag($0) }
                }
            }
            .frame(height: .xxlarge)
            .pickerStyle(.wheel)
        }
    }

    private var homeTeamNameInputField: some View {
        TextField(
            "",
            text: $inputState.homeParticipantName,
            prompt: Text("key_home".localized)
                .foregroundStyle(homeTeamNamePlaceholderColor)
        )
    }

    private var awayTeamNameInputField: some View {
        TextField(
            "",
            text: $inputState.awayParticipantName,
            prompt: Text("key_away".localized)
                .foregroundStyle(awayTeamNamePlaceholderColor)
        )
        .multilineTextAlignment(.trailing)
    }

    private var scoreInputFields: some View {
        HStack {
            TextField("key_score".localized, value: $inputState.homeParticipantScore, format: .number)
                .onChange(of: inputState.homeParticipantScore) { _, newScore in
                    enforceThreeDigitLimit(for: &inputState.homeParticipantScore, newValue: newScore)
                }

            Spacer()

            TextField("key_score".localized, value: $inputState.awayParticipantScore, format: .number)
                .onChange(of: inputState.awayParticipantScore) { _, newScore in
                    enforceThreeDigitLimit(for: &inputState.awayParticipantScore, newValue: newScore)
                }
                .multilineTextAlignment(.trailing)
        }
        .font(.largeTitle)
        .fontWeight(.bold)
        .keyboardType(.numberPad)
    }

    private func enforceThreeDigitLimit(for score: inout Int, newValue: Int) {
        let stringValue = String(newValue)

        if stringValue.count > 3 {
            score = Int(String(stringValue.prefix(3))) ?? 0
        }
    }
}

#Preview("MatchSectionView") {
    MatchSectionView(
        inputState: .constant(.init()),
        inputStateValidatorOuput: .init(
            isMatchNameValid: true,
            isLocationNameValid: true,
            isDurationValid: false,
            isHomeParticipantNameValid: false,
            isAwayParticipantNameValid: true
        )
    )
}
