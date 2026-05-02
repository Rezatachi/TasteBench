import SwiftUI

struct SectionHeader: View {
    let eyebrow: String
    let title: String

    var body: some View {
        VStack(alignment: .leading, spacing: MiraSpacing.xs) {
            Text(eyebrow.uppercased())
                .font(MiraTypography.caption)
                .tracking(1.4)
                .foregroundStyle(MiraColors.textSecondary)
            Text(title)
                .font(MiraTypography.heading)
                .foregroundStyle(MiraColors.textPrimary)
        }
    }
}
