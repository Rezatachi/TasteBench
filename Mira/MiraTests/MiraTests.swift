import XCTest
@testable import Mira

final class MiraTests: XCTestCase {
    func testJournalEntryCreationKeepsProvidedValues() {
        let createdAt = Date(timeIntervalSince1970: 1_700_000_000)

        let entry = JournalEntry(
            title: "A quiet walk",
            body: "I noticed the late afternoon light on the buildings.",
            mood: .calm,
            createdAt: createdAt
        )

        XCTAssertEqual(entry.title, "A quiet walk")
        XCTAssertEqual(entry.body, "I noticed the late afternoon light on the buildings.")
        XCTAssertEqual(entry.mood, .calm)
        XCTAssertEqual(entry.createdAt, createdAt)
    }

    func testMoodDisplayLabelsAreHumanReadable() {
        XCTAssertEqual(Mood.calm.displayName, "Calm")
        XCTAssertEqual(Mood.grateful.displayName, "Grateful")
        XCTAssertEqual(Mood.anxious.displayName, "Anxious")
        XCTAssertEqual(Mood.focused.displayName, "Focused")
        XCTAssertEqual(Mood.tired.displayName, "Tired")
        XCTAssertEqual(Mood.hopeful.displayName, "Hopeful")
    }

    func testJournalViewModelAddEntryPrependsEntry() {
        let viewModel = JournalViewModel(entries: [])

        viewModel.addEntry(
            title: "Evening notes",
            body: "A short reflection before sleep.",
            mood: .hopeful
        )

        XCTAssertEqual(viewModel.entries.count, 1)
        XCTAssertEqual(viewModel.entries.first?.title, "Evening notes")
        XCTAssertEqual(viewModel.entries.first?.body, "A short reflection before sleep.")
        XCTAssertEqual(viewModel.entries.first?.mood, .hopeful)
    }
}
