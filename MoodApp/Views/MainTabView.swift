import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            TimelineView()
                .tabItem {
                    Image(systemName: "clock.fill")
                    Text("时间线")
                }
            
            RecordView()
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                    Text("记录")
                }
            
            AnalyticsView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("统计")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("设置")
                }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
