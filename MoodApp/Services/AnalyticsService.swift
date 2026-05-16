import Foundation

enum AnalyticsPeriod: Int, CaseIterable, Identifiable {
    case week = 7
    case month = 30
    case quarter = 90
    case all = 0
    
    var id: Int { rawValue }
    
    var title: String {
        switch self {
        case .week: return "7天"
        case .month: return "30天"
        case .quarter: return "90天"
        case .all: return "全部"
        }
    }
    
    var days: Int? {
        return rawValue == 0 ? nil : rawValue
    }
}

struct AnalyticsStats {
    let averageMood: Double?
    let totalEntries: Int
    let continuousDays: Int
    let trendData: [(date: Date, moodLevel: Int)]
    let emojiDistribution: [String: Int]
    let period: AnalyticsPeriod
}

class AnalyticsService {
    private let moodService: MoodRecordServiceProtocol
    
    init(moodService: MoodRecordServiceProtocol) {
        self.moodService = moodService
    }
    
    func calculateStats(for period: AnalyticsPeriod) async -> AnalyticsStats {
        let averageMood = await moodService.getAverageMoodLevel(days: period.days)
        let totalEntries = await moodService.getTotalEntries()
        let continuousDays = await moodService.getContinuousDays()
        let trendData = await moodService.getMoodTrend(days: period.days)
        let emojiDistribution = await moodService.getEmojiDistribution()
        
        return AnalyticsStats(
            averageMood: averageMood,
            totalEntries: totalEntries,
            continuousDays: continuousDays,
            trendData: trendData,
            emojiDistribution: emojiDistribution,
            period: period
        )
    }
}
