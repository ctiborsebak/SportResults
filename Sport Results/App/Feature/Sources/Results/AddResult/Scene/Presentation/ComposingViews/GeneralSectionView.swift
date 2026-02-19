import Domain
import SwiftUI
import Theme

struct GeneralSectionView: View {
    @Binding var inputState: AddResultInputState
    let spacing = CGFloat.small

    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            sectionTitle

            Card {
                VStack(spacing: .small) {
                    disciplinePicker

                    Divider()

                    nameTextField

                    Divider()

                    locationTextField

                    Divider()

                    datePicker

                    Divider()

                    storagePicker
                }
            }
        }
        .textFieldStyle(.roundedBorder)
    }

    private var sectionTitle: some View {
        "key_section_general".localized
            .text
            .foregroundStyle(Color.Text.primary)
            .font(.title3)
            .fontWeight(.medium)
    }

    private var disciplinePicker: some View {
        HStack(spacing: .xxsmall) {
            "key_picker_title".localized.text

            Spacer()

            inputState.selectedDiscipline.icon
                .contentTransition(.symbolEffect(.replace))
                .foregroundStyle(inputState.persistenceKind.textColor)

            Picker("key_picker_title".localized, selection: $inputState.selectedDiscipline) {
                ForEach(Discipline.allCases) { discipline in
                    discipline.title.text.tag(discipline)
                }
            }
        }
    }

    private var nameTextField: some View {
        TextField(
            "",
            text: $inputState.matchName,
            prompt: Text("key_placeholder_match_name".localized)
                .foregroundStyle(Color.Semantic.error)
        )
    }

    private var locationTextField: some View {
        TextField(
            "",
            text: $inputState.location,
            prompt: Text("key_placeholder_match_location".localized)
                .foregroundStyle(Color.Semantic.error)
        )
    }

    private var datePicker: some View {
        DatePicker(
            "key_date".localized,
            selection: $inputState.date,
            displayedComponents: [.date]
        )
    }

    private var storagePicker: some View {
        HStack {
            "key_storage_type".localized.text

            Spacer()

            Picker("", selection: $inputState.persistenceKind) {
                ForEach(PersistenceKind.allCases) { kind in
                    kind.title.text.tag(kind)
                }
            }
        }
    }
}

#Preview("GeneralSectionView") {
    GeneralSectionView(
        inputState: .constant(.init())
    )
}
