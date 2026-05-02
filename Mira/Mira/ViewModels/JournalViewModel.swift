import Foundation
import Combine

final class JournalViewModel: ObservableObject {
    @Published private(set) var entries: [JournalEntry]

    init(entries: [JournalEntry] = SampleData.entries) {
        self.entries = entries.sorted { $0.createdAt > $1.createdAt }
    }

    var featuredEntry: JournalEntry? {
        entries.first
    }

    func addEntry(title: String, body: String, mood: Mood) {
        let cleanTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanBody = body.trimmingCharacters(in: .whitespacesAndNewlines)
        let resolvedTitle = cleanTitle.isEmpty ? Self.titleFromBody(cleanBody) : cleanTitle
        let entry = JournalEntry(title: resolvedTitle, body: cleanBody, mood: mood)
        entries.insert(entry, at: 0)
    }

    private static func titleFromBody(_ body: String) -> String {
        let firstLine = body
            .split(whereSeparator: \.isNewline)
            .first
            .map(String.init) ?? "Untitled reflection"

        return firstLine.count > 48 ? String(firstLine.prefix(45)) + "…" : firstLine
    }
}
