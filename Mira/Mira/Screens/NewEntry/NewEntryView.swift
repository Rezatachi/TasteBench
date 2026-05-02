import SwiftUI

struct NewEntryView: View {
    @ObservedObject var viewModel: JournalViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var bodyText = ""
    @State private var selectedMood: Mood = .calm

    private let prompt = "What do you want to remember about today?"

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: MiraSpacing.lg) {
                VStack(alignment: .leading, spacing: MiraSpacing.sm) {
                    Text("New reflection")
                        .font(MiraTypography.title)
                        .foregroundStyle(MiraColors.textPrimary)
                    Text(prompt)
                        .font(MiraTypography.bodySans)
                        .foregroundStyle(MiraColors.textSecondary)
                }

                TextField("Give this entry a title", text: $title)
                    .font(MiraTypography.heading)
                    .foregroundStyle(MiraColors.textPrimary)
                    .textFieldStyle(.plain)
                    .padding(MiraSpacing.md)
                    .miraSurface(cornerRadius: MiraRadius.md, borderOpacity: 0.7)

                TextEditor(text: $bodyText)
                    .font(MiraTypography.body)
                    .foregroundStyle(MiraColors.textPrimary)
                    .scrollContentBackground(.hidden)
                    .padding(MiraSpacing.sm)
                    .frame(minHeight: 220)
                    .miraSurface(cornerRadius: MiraRadius.lg, borderOpacity: 0.7)

                moodSelector

                Spacer(minLength: MiraSpacing.md)

                PrimaryButton(title: "Save reflection", isDisabled: !canSave) {
                    viewModel.addEntry(title: title, body: bodyText, mood: selectedMood)
                    dismiss()
                }
            }
            .padding(MiraSpacing.lg)
            .background(MiraColors.background.ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(MiraColors.textSecondary)
                }
            }
        }
    }

    private var moodSelector: some View {
        VStack(alignment: .leading, spacing: MiraSpacing.sm) {
            Text("Mood")
                .font(MiraTypography.caption)
                .foregroundStyle(MiraColors.textSecondary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: MiraSpacing.sm) {
                    ForEach(Mood.allCases) { mood in
                        Button {
                            selectedMood = mood
                        } label: {
                            MoodTag(mood: mood)
                                .overlay(
                                    Capsule().stroke(selectedMood == mood ? MiraColors.accent : .clear, lineWidth: 2)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private var canSave: Bool {
        !bodyText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
