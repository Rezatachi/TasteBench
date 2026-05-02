import SwiftUI

struct ReflectionPromptCard: View {
    let prompt: String

    var body: some View {
        VStack(alignment: .leading, spacing: MiraSpacing.md) {
            Text("Today’s prompt".uppercased())
                .font(MiraTypography.caption)
                .tracking(1.2)
                .foregroundStyle(MiraColors.textSecondary)

            Text(prompt)
                .font(MiraTypography.title)
                .foregroundStyle(MiraColors.textPrimary)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(MiraSpacing.lg)
        .miraSurface(cornerRadius: MiraRadius.xl, borderOpacity: 0.7)
    }
}
