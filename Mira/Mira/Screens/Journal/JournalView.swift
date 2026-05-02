import SwiftUI

struct JournalView: View {
    @ObservedObject var viewModel: JournalViewModel
    @State private var isShowingNewEntry = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: MiraSpacing.lg) {
                Text("Journal")
                    .font(MiraTypography.display)
                    .foregroundStyle(MiraColors.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                LazyVStack(spacing: MiraSpacing.md) {
                    ForEach(viewModel.entries) { entry in
                        NavigationLink(destination: EntryDetailView(entry: entry)) {
                            JournalEntryCard(entry: entry)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(MiraSpacing.lg)
        }
        .background(MiraColors.background.ignoresSafeArea())
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isShowingNewEntry = true
                } label: {
                    Image(systemName: "plus")
                }
                .tint(MiraColors.accent)
                .accessibilityLabel("New entry")
            }
        }
        .sheet(isPresented: $isShowingNewEntry) {
            NewEntryView(viewModel: viewModel)
        }
    }
}
