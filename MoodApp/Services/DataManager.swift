import Foundation

class DataManager {
    static let shared = DataManager()
    
    private let repository: MoodRepositoryProtocol
    private let service: MoodRecordServiceProtocol
    
    private init() {
        self.repository = InMemoryRepository()
        self.service = MoodRecordService(repository: repository)
    }
    
    var moodService: MoodRecordServiceProtocol {
        return service
    }
}
