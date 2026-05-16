import Foundation

protocol MoodRecordServiceProtocol {
    func createEntry(_ dto: MoodEntryDTO) async throws
    func updateEntry(_ dto: MoodEntryDTO) async throws
    func deleteEntry(id: UUID) async throws
    func getEntries(after date: Date?, limit: Int) async -> [MoodEntryDTO]
    
    // 统计分析方法
    func getAverageMoodLevel(days: Int?) async -> Double?
    func getTotalEntries() async -> Int
    func getMoodTrend(days: Int?) async -> [(date: Date, moodLevel: Int)]
    func getEmojiDistribution() async -> [String: Int]
    func getContinuousDays() async -> Int
}

class MoodRecordService: MoodRecordServiceProtocol {
    private let repository: MoodRepositoryProtocol
    
    init(repository: MoodRepositoryProtocol) {
        self.repository = repository
    }
    
    func createEntry(_ dto: MoodEntryDTO) async throws {
        try await MainActor.run {
            try repository.createEntry(dto)
        }
    }
    
    func updateEntry(_ dto: MoodEntryDTO) async throws {
        try await MainActor.run {
            try repository.updateEntry(dto)
        }
    }
    
    func deleteEntry(id: UUID) async throws {
        try await MainActor.run {
            try repository.deleteEntry(id: id)
        }
    }
    
    func getEntries(after date: Date?, limit: Int) async -> [MoodEntryDTO] {
        await MainActor.run {
            repository.getEntries(after: date, limit: limit)
        }
    }
    
    // MARK: - 统计分析方法实现
    
    func getAverageMoodLevel(days: Int?) async -> Double? {
        await MainActor.run {
            if let repo = repository as? InMemoryRepository {
                return repo.calculateAverageMood(days: days)
            }
            return nil
        }
    }
    
    func getTotalEntries() async -> Int {
        await MainActor.run {
            repository.getAllEntries().count
        }
    }
    
    func getMoodTrend(days: Int?) async -> [(date: Date, moodLevel: Int)] {
        await MainActor.run {
            if let repo = repository as? InMemoryRepository {
                return repo.getMoodTrendData(days: days)
            }
            return []
        }
    }
    
    func getEmojiDistribution() async -> [String: Int] {
        await MainActor.run {
            if let repo = repository as? InMemoryRepository {
                return repo.getEmojiDistributionData()
            }
            return [:]
        }
    }
    
    func getContinuousDays() async -> Int {
        await MainActor.run {
            if let repo = repository as? InMemoryRepository {
                return repo.calculateContinuousDays()
            }
            return 0
        }
    }
}
