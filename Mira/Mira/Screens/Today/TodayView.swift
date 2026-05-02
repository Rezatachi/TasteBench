import SwiftUI

struct TodayView: View {
    @ObservedObject var viewModel: JournalViewModel
    @State private var isShowingNewEntry = false

    private let prompt = "What felt quietly important today?"

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: MiraSpacing.xl) {
                    header
                    ReflectionPromptCard(prompt: prompt)
                    recentEntrySection
                    PrimaryButton(title: "Write a reflection", systemImage: "square.and.pencil") {
                        isShowingNewEntry = true
                    }
                    journalLink
                }
                .padding(.horizontal, MiraSpacing.lg)
                .padding(.top, MiraSpacing.lg)
                .padding(.bottom, MiraSpacing.xl)
            }
            .background(MiraColors.background.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $isShowingNewEntry) {
                NewEntryView(viewModel: viewModel)
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: MiraSpacing.sm) {
            Text(greeting)
                .font(MiraTypography.display)
                .foregroundStyle(MiraColors.textPrimary)
            Text(Date().formatted(date: .complete, time: .omitted))
                .font(MiraTypography.bodySans)
                .foregroundStyle(MiraColors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var recentEntrySection: some View {
        VStack(alignment: .leading, spacing: MiraSpacing.md) {
            SectionHeader(eyebrow: "Recent reflection", title: "A note from your journal")

            if let entry = viewModel.featuredEntry {
                NavigationLink(destination: EntryDetailView(entry: entry)) {
                    JournalEntryCard(entry: entry)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var journalLink: some View {
        NavigationLink(destination: JournalView(viewModel: viewModel)) {
            HStack {
                Text("Browse Journal")
                    .font(MiraTypography.bodySans.weight(.semibold))
                Spacer()
                Image(systemName: "arrow.right")
            }
            .foregroundStyle(MiraColors.accent)
            .padding(MiraSpacing.lg)
            .miraSurface(cornerRadius: MiraRadius.lg, borderOpacity: 0.5)
        }
        .buttonStyle(.plain)
    }

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good morning"
        case 12..<17: return "Good afternoon"
        default: return "Good evening"
        }
    }
}
