import Foundation
import Combine

@MainActor
class AnalyticsViewModel: ObservableObject {
    @Published var stats: AnalyticsStats?
    @Published var selectedPeriod: AnalyticsPeriod = .week
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let analyticsService: AnalyticsService
    private var cancellables = Set<AnyCancellable>()
    
    init(analyticsService: AnalyticsService) {
        self.analyticsService = analyticsService
    }
    
    func loadStats() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let newStats = await analyticsService.calculateStats(for: selectedPeriod)
                
                await MainActor.run {
                    self.stats = newStats
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "加载统计数据失败"
                    self.isLoading = false
                }
            }
        }
    }
    
    func changePeriod(_ period: AnalyticsPeriod) {
        selectedPeriod = period
        loadStats()
    }
}
