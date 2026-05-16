import Foundation
import CoreData

protocol MoodRepositoryProtocol {
    func createEntry(_ dto: MoodEntryDTO) throws
    func updateEntry(_ dto: MoodEntryDTO) throws
    func deleteEntry(id: UUID) throws
    func getEntries(after date: Date?, limit: Int) -> [MoodEntryDTO]
    func getAllTags() -> [TagDTO]
    func createTag(_ dto: TagDTO) throws
    
    // 统计分析方法
    func getAllEntries() -> [MoodEntryDTO]
}

class MoodRepository: MoodRepositoryProtocol {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func createEntry(_ dto: MoodEntryDTO) throws {
        // Note: This requires the CoreData entities to be generated from .xcdatamodeld
        // For now, this is a placeholder that will work once Xcode project is created
        print("Repository: Creating entry - \(dto.moodEmoji)")
        // Implementation will use MoodEntry(context: context)
    }
    
    func updateEntry(_ dto: MoodEntryDTO) throws {
        print("Repository: Updating entry - \(dto.id)")
    }
    
    func deleteEntry(id: UUID) throws {
        print("Repository: Deleting entry - \(id)")
    }
    
    func getEntries(after date: Date?, limit: Int) -> [MoodEntryDTO] {
        // Return sample data for now
        return MoodEntryDTO.sampleEntries.prefix(limit).map { $0 }
    }
    
    func getAllTags() -> [TagDTO] {
        return PresetTag.allCases.map { $0.toDTO() }
    }
    
    func createTag(_ dto: TagDTO) throws {
        print("Repository: Creating tag - \(dto.name)")
    }
}

enum RepositoryError: Error {
    case notFound
    case saveFailed
}

// 工厂方法：根据条件返回不同的 Repository 实现
func makeRepository(useCoreData: Bool = false, context: NSManagedObjectContext? = nil) -> MoodRepositoryProtocol {
    if useCoreData, let context = context {
        return MoodRepository(context: context)
    }
    return InMemoryRepository()
}
