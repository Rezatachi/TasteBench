import Foundation

enum Mood: String, CaseIterable, Identifiable, Equatable {
    case calm
    case grateful
    case anxious
    case focused
    case tired
    case hopeful

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .calm: "Calm"
        case .grateful: "Grateful"
        case .anxious: "Anxious"
        case .focused: "Focused"
        case .tired: "Tired"
        case .hopeful: "Hopeful"
        }
    }
}
