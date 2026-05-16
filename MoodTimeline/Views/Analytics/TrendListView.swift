import SwiftUI

struct TrendListView: View {
    let trendData: [(date: Date, moodLevel: Int)]
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("心情趋势")
                .font(.headline)
                .padding(.horizontal)
            
            if trendData.isEmpty {
                Text("暂无数据")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                ForEach(trendData.prefix(10), id: \.date) { item in
                    HStack {
                        Text(dateFormatter.string(from: item.date))
                            .font(.subheadline)
                            .frame(width: 50, alignment: .leading)
                        
                        Text(moodEmoji(for: item.moodLevel))
                            .font(.title3)
                        
                        Spacer()
                        
                        Text("\(item.moodLevel)")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                }
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    
    private func moodEmoji(for level: Int) -> String {
        let emojis = ["😢", "😟", "😐", "🙂", "😊"]
        let index = max(0, min(level - 1, emojis.count - 1))
        return emojis[index]
    }
}

struct TrendListView_Previews: PreviewProvider {
    static var previews: some View {
        TrendListView(trendData: [
            (Date(), 7),
            (Date().addingTimeInterval(-86400), 5),
            (Date().addingTimeInterval(-86400 * 2), 8)
        ])
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
