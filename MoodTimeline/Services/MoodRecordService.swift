import Foundation

protocol MoodRecordServiceProtocol {
    func createEntry(_ dto: MoodEntryDTO) async throws
    func updateEntry(_ dto: MoodEntryDTO) async throws
    func deleteEntry(id: UUID) async throws
    func getEntries(after date: Date?, limit: Int) async -> [MoodEntryDTO]
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
}
