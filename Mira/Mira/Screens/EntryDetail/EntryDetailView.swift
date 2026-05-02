import SwiftUI

struct EntryDetailView: View {
    let entry: JournalEntry

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: MiraSpacing.lg) {
                VStack(alignment: .leading, spacing: MiraSpacing.md) {
                    MoodTag(mood: entry.mood)

                    Text(entry.title)
                        .font(MiraTypography.display)
                        .foregroundStyle(MiraColors.textPrimary)
                        .lineSpacing(2)

                    Text(entry.createdAt.formatted(date: .complete, time: .omitted))
                        .font(MiraTypography.bodySans)
                        .foregroundStyle(MiraColors.textSecondary)
                }

                Divider()
                    .overlay(MiraColors.border)

                Text(entry.body)
                    .font(MiraTypography.body)
                    .foregroundStyle(MiraColors.textPrimary)
                    .lineSpacing(7)

                actionRow
                    .padding(.top, MiraSpacing.lg)
            }
            .padding(MiraSpacing.lg)
        }
        .background(MiraColors.background.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }

    private var actionRow: some View {
        HStack(spacing: MiraSpacing.md) {
            Button("Edit") {}
            Button("Delete") {}
        }
        .font(MiraTypography.caption)
        .foregroundStyle(MiraColors.textSecondary)
        .buttonStyle(.bordered)
        .controlSize(.small)
        .disabled(true)
        .accessibilityHint("Editing and deletion are visual placeholders in Mira v0")
    }
}
