import Foundation
import Combine

class RecordViewModel: ObservableObject {
    @Published var moodEmoji: String = "😊"
    @Published var intensity: Int = 5
    @Published var note: String?
    @Published var triggerEvent: String?
    @Published var selectedTagIDs: [UUID] = []
    @Published var sleepHours: Double = 0.0
    @Published var exerciseMinutes: Int = 0
    @Published var energyLevel: Int = 5
    @Published var photoData: Data?
    
    private let service: MoodRecordServiceProtocol
    
    init(service: MoodRecordServiceProtocol = MoodRecordService(
        repository: MoodRepository(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
    )) {
        self.service = service
    }
    
    var isValid: Bool {
        !moodEmoji.isEmpty && intensity >= 1 && intensity <= 10
    }
    
    func saveEntry() async {
        let dto = MoodEntryDTO(
            moodEmoji: moodEmoji,
            moodLevel: mapEmojiToLevel(moodEmoji),
            intensity: intensity,
            note: note,
            triggerEvent: triggerEvent,
            tagIDs: selectedTagIDs,
            sleepHours: sleepHours > 0 ? sleepHours : nil,
            exerciseMinutes: exerciseMinutes > 0 ? exerciseMinutes : nil,
            energyLevel: energyLevel > 0 ? energyLevel : nil
        )
        
        do {
            try await service.createEntry(dto)
            print("✅ Entry saved successfully")
        } catch {
            print("❌ Save error: \(error)")
        }
    }
    
    private func mapEmojiToLevel(_ emoji: String) -> Int {
        let mapping: [String: Int] = [
            "😡": 1, "😢": 2, "😐": 3, "😊": 4, "😍": 5,
            "🤔": 3, "😴": 2, "🎉": 5, "😰": 2, "🥰": 5
        ]
        return mapping[emoji] ?? 3
    }
}
