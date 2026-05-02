import SwiftUI

extension Mood {
    var tintColor: Color {
        switch self {
        case .calm: Color(red: 0.43, green: 0.57, blue: 0.52)
        case .grateful: Color(red: 0.71, green: 0.49, blue: 0.28)
        case .anxious: Color(red: 0.61, green: 0.50, blue: 0.73)
        case .focused: Color(red: 0.38, green: 0.49, blue: 0.66)
        case .tired: Color(red: 0.55, green: 0.52, blue: 0.47)
        case .hopeful: Color(red: 0.55, green: 0.60, blue: 0.34)
        }
    }
}
