import Foundation
import Combine

@MainActor
class AnalyticsViewModel: ObservableObject {
    @Published var stats: AnalyticsStats?
    @Published var selectedPeriod: AnalyticsPeriod = .week
    @Published var isLoading = false
    
    private let analyticsService: AnalyticsService
    private var cancellables = Set<AnyCancellable>()
    private var currentTask: Task<Void, Never>?
    
    init(analyticsService: AnalyticsService) {
        self.analyticsService = analyticsService
    }
    
    func loadStats() {
        // 取消之前的任务，避免竞态条件
        currentTask?.cancel()
        
        isLoading = true
        
        let task = Task { @MainActor in
            let newStats = await analyticsService.calculateStats(for: selectedPeriod)
            
            // 检查任务是否被取消
            if !Task.isCancelled {
                self.stats = newStats
                self.isLoading = false
            }
        }
        
        currentTask = task
    }
    
    func changePeriod(_ period: AnalyticsPeriod) {
        selectedPeriod = period
        loadStats()
    }
}
