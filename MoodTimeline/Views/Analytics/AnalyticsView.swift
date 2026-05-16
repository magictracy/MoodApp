import SwiftUI

struct AnalyticsView: View {
    @StateObject private var viewModel: AnalyticsViewModel
    
    init() {
        let analyticsService = AnalyticsService(
            moodService: DataManager.shared.moodService
        )
        _viewModel = StateObject(wrappedValue: AnalyticsViewModel(
            analyticsService: analyticsService
        ))
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 周期选择器
                    periodSelector
                    
                    // 加载状态
                    if viewModel.isLoading {
                        ProgressView("加载中...")
                            .padding()
                    } else if let stats = viewModel.stats {
                        // 统计卡片网格
                        statsGrid(stats: stats)
                        
                        // 趋势列表
                        TrendListView(trendData: stats.trendData)
                            .padding(.horizontal)
                    } else {
                        emptyState
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("📊 情绪分析")
            .onAppear {
                viewModel.loadStats()
            }
        }
    }
    
    private var periodSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(AnalyticsPeriod.allCases) { period in
                    Button(action: {
                        withAnimation(.easeInOut) {
                            viewModel.changePeriod(period)
                        }
                    }) {
                        Text(period.title)
                            .font(.subheadline)
                            .fontWeight(viewModel.selectedPeriod == period ? .bold : .regular)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                viewModel.selectedPeriod == period
                                    ? Color.blue
                                    : Color.gray.opacity(0.2)
                            )
                            .foregroundColor(
                                viewModel.selectedPeriod == period
                                    ? .white
                                    : .primary
                            )
                            .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    private func statsGrid(stats: AnalyticsStats) -> some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            StatCardView(
                title: "平均心情",
                value: stats.averageMood != nil ? String(format: "%.1f", stats.averageMood!) : "暂无数据",
                icon: "heart.fill",
                color: .red
            )
            
            StatCardView(
                title: "记录总数",
                value: "\(stats.totalEntries)",
                icon: "list.bullet",
                color: .blue
            )
            
            StatCardView(
                title: "连续天数",
                value: "\(stats.continuousDays)",
                icon: "flame.fill",
                color: .orange
            )
            
            StatCardView(
                title: "最常用",
                value: mostUsedEmoji(stats: stats).isEmpty ? "暂无数据" : mostUsedEmoji(stats: stats),
                icon: "star.fill",
                color: .yellow
            )
        }
        .padding(.horizontal)
    }
    
    private func mostUsedEmoji(stats: AnalyticsStats) -> String {
        guard let topEmoji = stats.emojiDistribution.max(by: { $0.value < $1.value })?.key else {
            return "--"
        }
        return topEmoji
    }
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "chart.bar.fill")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("暂无统计数据")
                .font(.headline)
            
            Text("记录第一条心情后，这里将展示您的情绪分析")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 40)
    }
}

struct AnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsView()
    }
}
