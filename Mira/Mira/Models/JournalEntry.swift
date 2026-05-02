import Foundation

struct JournalEntry: Identifiable, Equatable {
    let id: UUID
    var title: String
    var body: String
    var mood: Mood
    var createdAt: Date

    init(
        id: UUID = UUID(),
        title: String,
        body: String,
        mood: Mood,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.body = body
        self.mood = mood
        self.createdAt = createdAt
    }
}
