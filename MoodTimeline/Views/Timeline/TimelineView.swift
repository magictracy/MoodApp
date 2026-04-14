import SwiftUI

struct TimelineView: View {
    @State private var entries: [MoodEntryDTO] = []
    
    var body: some View {
        NavigationView {
            Group {
                if entries.isEmpty {
                    EmptyStateView()
                } else {
                    TimelineListView(entries: entries)
                }
            }
            .navigationTitle("📅 心情时间线")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: RecordView()) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .onAppear {
            loadEntries()
        }
    }
    
    private func loadEntries() {
        // TODO: Load from service
        entries = MoodEntryDTO.sampleEntries
    }
}

struct TimelineListView: View {
    let entries: [MoodEntryDTO]
    
    var body: some View {
        List {
            ForEach(groupEntriesByDate(entries), id: \.date) { group in
                Section(header: Text(formatDate(group.date))) {
                    ForEach(group.entries, id: \.id) { entry in
                        MoodEntryRow(entry: entry)
                    }
                }
            }
        }
    }
    
    private func groupEntriesByDate(_ entries: [MoodEntryDTO]) -> [(date: Date, entries: [MoodEntryDTO])] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: entries) { entry in
            calendar.startOfDay(for: entry.timestamp)
        }
        
        return grouped.map { (date: $0.key, entries: $0.value.sorted { $0.timestamp > $1.timestamp }) }
            .sorted { $0.date > $1.date }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日 EEEE"
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter.string(from: date)
    }
}

struct MoodEntryRow: View {
    let entry: MoodEntryDTO
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(entry.moodEmoji)
                    .font(.largeTitle)
                
                VStack(alignment: .leading) {
                    Text(formatTime(entry.timestamp))
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    if let note = entry.note, !note.isEmpty {
                        Text(note)
                            .font(.body)
                    }
                }
                
                Spacer()
                
                Text("强度: \(entry.intensity)/10")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if let triggerEvent = entry.triggerEvent, !triggerEvent.isEmpty {
                Text("触发: \(triggerEvent)")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
        }
        .padding(.vertical, 4)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "smiley")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("还没有心情记录")
                .font(.headline)
            
            Text("点击右下角 + 开始记录吧")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView()
    }
}
