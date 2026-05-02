import Foundation

enum SampleData {
    static let entries: [JournalEntry] = [
        JournalEntry(
            title: "A slower kind of focus",
            body: "This morning felt unusually spacious. I walked without headphones and let the city stay quiet around me. The work still felt big, but less urgent than yesterday.",
            mood: .focused,
            createdAt: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        ),
        JournalEntry(
            title: "Tiny signs of momentum",
            body: "I noticed three small wins today: a kind message, a clean page of notes, and the feeling that one problem finally has edges. Nothing dramatic, but enough.",
            mood: .grateful,
            createdAt: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date()
        ),
        JournalEntry(
            title: "Let the evening be gentle",
            body: "I am trying not to turn rest into another assignment. Tea, a book, and a little quiet are enough for tonight.",
            mood: .calm,
            createdAt: Calendar.current.date(byAdding: .day, value: -4, to: Date()) ?? Date()
        ),
        JournalEntry(
            title: "A thought I kept returning to",
            body: "The anxious part of me wants certainty. The wiser part knows I only need the next honest step.",
            mood: .anxious,
            createdAt: Calendar.current.date(byAdding: .day, value: -6, to: Date()) ?? Date()
        )
    ]
}
