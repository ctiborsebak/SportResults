import Architecture

struct AddResultInputStateValidator: Validating {
    func validate(_ input: AddResultInputState) -> AddResultInputStateValidatorOutput {
        AddResultInputStateValidatorOutput(
            isMatchNameValid: !input.matchName.isEmpty,
            isLocationNameValid: !input.location.isEmpty,
            isDurationValid: input.hasDurationChanged,
            isHomeParticipantNameValid: !input.homeParticipantName.isEmpty,
            isAwayParticipantNameValid: !input.awayParticipantName.isEmpty
        )
    }
}

struct AddResultInputStateValidatorOutput: ValidatorOutput {
    let isMatchNameValid: Bool
    let isLocationNameValid: Bool
    let isDurationValid: Bool
    let isHomeParticipantNameValid: Bool
    let isAwayParticipantNameValid: Bool

    var isValid: Bool {
        isMatchNameValid
        && isLocationNameValid
        && isDurationValid
        && isHomeParticipantNameValid
        && isAwayParticipantNameValid
    }
}
