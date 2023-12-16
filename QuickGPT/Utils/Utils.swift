import Foundation

func convertToBoolOrString(_ input: String) -> Any {
    switch Bool(input.lowercased()) {
    case true:
        return true
    case false:
        return false
    default:
        return input
    }
}
