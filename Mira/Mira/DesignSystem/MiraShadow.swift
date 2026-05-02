import SwiftUI

struct MiraSoftShadow: ViewModifier {
    func body(content: Content) -> some View {
        content.shadow(color: Color.black.opacity(0.07), radius: 18, x: 0, y: 10)
    }
}

extension View {
    func miraSoftShadow() -> some View {
        modifier(MiraSoftShadow())
    }
}
