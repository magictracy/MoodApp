import Foundation

class InMemoryRepository: MoodRepositoryProtocol {
    private var entries: [UUID: MoodEntryDTO] = [:]
    private var tags: [UUID: TagDTO] = [:]
    private let queue = DispatchQueue(label: "com.moodtimeline.inmemory.repository")
    
    init() {
        // 初始化示例数据
        loadSampleData()
    }
    
    private func loadSampleData() {
        // 加载预设标签
        for presetTag in PresetTag.allCases {
            let tag = presetTag.toDTO()
            tags[tag.id] = tag
        }
        
        // 加载示例心情记录
        for entry in MoodEntryDTO.sampleEntries {
            entries[entry.id] = entry
        }
    }
    
    func createEntry(_ dto: MoodEntryDTO) throws {
        queue.sync {
            entries[dto.id] = dto
        }
        print("✅ InMemoryRepository: Created entry - \(dto.moodEmoji) at \(dto.timestamp)")
    }
    
    func updateEntry(_ dto: MoodEntryDTO) throws {
        queue.sync {
            guard entries[dto.id] != nil else {
                throw RepositoryError.notFound
            }
            entries[dto.id] = dto
        }
        print("✅ InMemoryRepository: Updated entry - \(dto.id)")
    }
    
    func deleteEntry(id: UUID) throws {
        queue.sync {
            guard entries.removeValue(forKey: id) != nil else {
                throw RepositoryError.notFound
            }
        }
        print("✅ InMemoryRepository: Deleted entry - \(id)")
    }
    
    func getEntries(after date: Date?, limit: Int) -> [MoodEntryDTO] {
        return queue.sync {
            var filteredEntries = Array(entries.values)
            
            // 时间过滤
            if let afterDate = date {
                filteredEntries = filteredEntries.filter { $0.timestamp > afterDate }
            }
            
            // 按时间降序排序（最新的在前）
            filteredEntries.sort { $0.timestamp > $1.timestamp }
            
            // 限制数量
            return Array(filteredEntries.prefix(limit))
        }
    }
    
    func getAllTags() -> [TagDTO] {
        return queue.sync {
            return Array(tags.values)
        }
    }
    
    func createTag(_ dto: TagDTO) throws {
        queue.sync {
            tags[dto.id] = dto
        }
        print("✅ InMemoryRepository: Created tag - \(dto.name)")
    }
    
    // MARK: - 统计分析方法
    
    func getAllEntries() -> [MoodEntryDTO] {
        return queue.sync {
            return Array(entries.values).sorted { $0.timestamp > $1.timestamp }
        }
    }
    
    private func getEntriesForPeriod(days: Int?) -> [MoodEntryDTO] {
        return queue.sync {
            guard let days = days else {
                return Array(entries.values).sorted { $0.timestamp > $1.timestamp }
            }
            
            let cutoffDate = Calendar.current.date(byAdding: .day, value: -days, to: Date())!
            return entries.values.filter { $0.timestamp >= cutoffDate }
                                 .sorted { $0.timestamp > $1.timestamp }
        }
    }
    
    func calculateAverageMood(days: Int?) -> Double? {
        let periodEntries = getEntriesForPeriod(days: days)
        guard !periodEntries.isEmpty else { return nil }
        
        let sum = periodEntries.reduce(0) { $0 + $1.moodLevel }
        return Double(sum) / Double(periodEntries.count)
    }
    
    func getMoodTrendData(days: Int?) -> [(date: Date, moodLevel: Int)] {
        let periodEntries = getEntriesForPeriod(days: days)
        return periodEntries.map { ($0.timestamp, $0.moodLevel) }
    }
    
    func getEmojiDistributionData() -> [String: Int] {
        return queue.sync {
            var distribution: [String: Int] = [:]
            for entry in entries.values {
                distribution[entry.moodEmoji, default: 0] += 1
            }
            return distribution
        }
    }
    
    func calculateContinuousDays() -> Int {
        return queue.sync {
            guard !entries.isEmpty else { return 0 }
            
            let sortedEntries = Array(entries.values).sorted { $0.timestamp > $1.timestamp }
            let calendar = Calendar.current
            
            var continuousDays = 1
            var currentDate = calendar.startOfDay(for: sortedEntries[0].timestamp)
            
            for i in 1..<sortedEntries.count {
                let entryDate = calendar.startOfDay(for: sortedEntries[i].timestamp)
                let dayDiff = calendar.dateComponents([.day], from: entryDate, to: currentDate).day ?? 0
                
                if dayDiff == 1 {
                    continuousDays += 1
                    currentDate = entryDate
                } else if dayDiff > 1 {
                    break
                }
            }
            
            return continuousDays
        }
    }
}
