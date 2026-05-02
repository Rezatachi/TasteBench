import SwiftUI

@main
struct MiraApp: App {
    @StateObject private var journalViewModel = JournalViewModel()

    var body: some Scene {
        WindowGroup {
            TodayView(viewModel: journalViewModel)
        }
    }
}
