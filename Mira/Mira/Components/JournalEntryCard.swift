import SwiftUI

struct JournalEntryCard: View {
    let entry: JournalEntry

    var body: some View {
        VStack(alignment: .leading, spacing: MiraSpacing.md) {
            HStack(alignment: .firstTextBaseline) {
                Text(entry.createdAt.formatted(date: .abbreviated, time: .omitted))
                    .font(MiraTypography.caption)
                    .foregroundStyle(MiraColors.textSecondary)
                Spacer()
                MoodTag(mood: entry.mood)
            }

            VStack(alignment: .leading, spacing: MiraSpacing.sm) {
                Text(entry.title)
                    .font(MiraTypography.heading)
                    .foregroundStyle(MiraColors.textPrimary)
                    .lineLimit(2)

                Text(entry.body)
                    .font(MiraTypography.body)
                    .foregroundStyle(MiraColors.textSecondary)
                    .lineSpacing(3)
                    .lineLimit(3)
            }
        }
        .padding(MiraSpacing.lg)
        .miraSurface(cornerRadius: MiraRadius.lg, borderOpacity: 0.65, shadow: true)
    }
}
