import SwiftUI

struct PrimaryButton: View {
    let title: String
    var systemImage: String? = nil
    var isDisabled = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: MiraSpacing.sm) {
                if let systemImage {
                    Image(systemName: systemImage)
                }
                Text(title)
            }
            .font(MiraTypography.caption)
            .foregroundStyle(Color.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(isDisabled ? MiraColors.textSecondary.opacity(0.45) : MiraColors.accent, in: RoundedRectangle(cornerRadius: MiraRadius.md, style: .continuous))
        }
        .disabled(isDisabled)
        .buttonStyle(.plain)
    }
}
