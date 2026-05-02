import SwiftUI

struct MoodTag: View {
    let mood: Mood

    var body: some View {
        Text(mood.displayName)
            .font(MiraTypography.caption)
            .foregroundStyle(mood.tintColor)
            .padding(.horizontal, MiraSpacing.sm)
            .padding(.vertical, MiraSpacing.xs)
            .background(mood.tintColor.opacity(0.14), in: Capsule())
            .overlay(Capsule().stroke(mood.tintColor.opacity(0.22), lineWidth: 1))
    }
}
