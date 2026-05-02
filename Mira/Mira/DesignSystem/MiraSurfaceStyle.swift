import SwiftUI

struct MiraSurfaceStyle: ViewModifier {
    let cornerRadius: CGFloat
    let borderOpacity: Double
    let shadow: Bool

    func body(content: Content) -> some View {
        content
            .background(
                MiraColors.surface,
                in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(MiraColors.border.opacity(borderOpacity), lineWidth: 1)
            )
            .if(shadow) { view in
                view.miraSoftShadow()
            }
    }
}

extension View {
    func miraSurface(
        cornerRadius: CGFloat = MiraRadius.lg,
        borderOpacity: Double = 0.65,
        shadow: Bool = false
    ) -> some View {
        modifier(MiraSurfaceStyle(cornerRadius: cornerRadius, borderOpacity: borderOpacity, shadow: shadow))
    }

    @ViewBuilder
    fileprivate func `if`<Content: View>(
        _ condition: Bool,
        transform: (Self) -> Content
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
