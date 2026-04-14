import Foundation

struct MoodEntryDTO: Identifiable, Codable {
    let id: UUID
    let timestamp: Date
    let moodEmoji: String
    let moodLevel: Int
    let intensity: Int
    let note: String?
    let triggerEvent: String?
    let tagIDs: [UUID]
    let sleepHours: Double?
    let exerciseMinutes: Int?
    let energyLevel: Int?
    let photoFilename: String?
    
    init(
        id: UUID = UUID(),
        timestamp: Date = Date(),
        moodEmoji: String,
        moodLevel: Int,
        intensity: Int,
        note: String? = nil,
        triggerEvent: String? = nil,
        tagIDs: [UUID] = [],
        sleepHours: Double? = nil,
        exerciseMinutes: Int? = nil,
        energyLevel: Int? = nil,
        photoFilename: String? = nil
    ) {
        self.id = id
        self.timestamp = timestamp
        self.moodEmoji = moodEmoji
        self.moodLevel = moodLevel
        self.intensity = intensity
        self.note = note
        self.triggerEvent = triggerEvent
        self.tagIDs = tagIDs
        self.sleepHours = sleepHours
        self.exerciseMinutes = exerciseMinutes
        self.energyLevel = energyLevel
        self.photoFilename = photoFilename
    }
}

extension MoodEntryDTO {
    static let sampleEntries: [MoodEntryDTO] = [
        MoodEntryDTO(
            timestamp: Date().addingTimeInterval(-3600),
            moodEmoji: "😊",
            moodLevel: 4,
            intensity: 8,
            note: "完成了重要项目演示",
            triggerEvent: "工作汇报",
            tagIDs: [],
            sleepHours: 7.5,
            exerciseMinutes: 30,
            energyLevel: 7
        ),
        MoodEntryDTO(
            timestamp: Date().addingTimeInterval(-86400),
            moodEmoji: "😐",
            moodLevel: 3,
            intensity: 4,
            note: "早起有点困",
            tagIDs: [],
            sleepHours: 6.0,
            energyLevel: 4
        )
    ]
}
