import SwiftUI

struct RecordView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = RecordViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                // 心情选择
                Section(header: Text("选择心情")) {
                    EmojiPicker(selectedEmoji: $viewModel.moodEmoji)
                }
                
                // 强度滑块
                Section(header: Text("强度")) {
                    HStack {
                        Slider(value: Binding(
                            get: { Double(viewModel.intensity) },
                            set: { viewModel.intensity = Int($0) }
                        ), in: 1...10, step: 1)
                        
                        Text("\(viewModel.intensity)/10")
                            .frame(width: 50)
                    }
                }
                
                // 触发事件
                Section(header: Text("发生了什么?")) {
                    TextField("输入触发事件...", text: Binding(
                        get: { viewModel.triggerEvent ?? "" },
                        set: { viewModel.triggerEvent = $0.isEmpty ? nil : $0 }
                    ))
                }
                
                // 备注
                Section(header: Text("备注 (可选)")) {
                    TextEditor(text: Binding(
                        get: { viewModel.note ?? "" },
                        set: { viewModel.note = $0.isEmpty ? nil : $0 }
                    ))
                    .frame(height: 100)
                }
                
                // 标签
                Section(header: Text("标签")) {
                    TagSelector(selectedTagIDs: $viewModel.selectedTagIDs)
                }
                
                // 身体状态
                Section(header: Text("身体状态")) {
                    HStack {
                        Text("睡眠")
                        Spacer()
                        Stepper("\(viewModel.sleepHours, specifier: "%.1f")h",
                                value: $viewModel.sleepHours,
                                in: 0...24,
                                step: 0.5)
                    }
                    
                    HStack {
                        Text("运动")
                        Spacer()
                        Stepper("\(viewModel.exerciseMinutes)min",
                                value: $viewModel.exerciseMinutes,
                                in: 0...300,
                                step: 5)
                    }
                    
                    HStack {
                        Text("精力")
                        Slider(value: Binding(
                            get: { Double(viewModel.energyLevel) },
                            set: { viewModel.energyLevel = Int($0) }
                        ), in: 1...10, step: 1)
                        Text("\(viewModel.energyLevel)/10")
                            .frame(width: 50)
                    }
                }
            }
            .navigationTitle("✏️ 记录心情")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        Task {
                            await viewModel.saveEntry()
                            dismiss()
                        }
                    }
                    .disabled(!viewModel.isValid)
                }
            }
        }
    }
}

struct EmojiPicker: View {
    @Binding var selectedEmoji: String
    
    let emojis = ["😊", "😢", "😡", "😐", "😍", "🤔", "😴", "🎉", "😰", "🥰"]
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))], spacing: 12) {
            ForEach(emojis, id: \.self) { emoji in
                Button(action: {
                    selectedEmoji = emoji
                }) {
                    Text(emoji)
                        .font(.system(size: 40))
                        .scaleEffect(selectedEmoji == emoji ? 1.3 : 1.0)
                        .animation(.spring(), value: selectedEmoji)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

struct TagSelector: View {
    @Binding var selectedTagIDs: [UUID]
    @State private var availableTags: [TagDTO] = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            WrapLayout {
                ForEach(availableTags) { tag in
                    TagChip(tag: tag, isSelected: selectedTagIDs.contains(tag.id)) {
                        toggleTag(tag.id)
                    }
                }
            }
        }
        .onAppear {
            loadTags()
        }
    }
    
    private func loadTags() {
        availableTags = PresetTag.allCases.map { $0.toDTO() }
    }
    
    private func toggleTag(_ id: UUID) {
        if let index = selectedTagIDs.firstIndex(of: id) {
            selectedTagIDs.remove(at: index)
        } else {
            selectedTagIDs.append(id)
        }
    }
}

struct TagChip: View {
    let tag: TagDTO
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(tag.name)
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color(hex: tag.colorHex) : Color.gray.opacity(0.2))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(16)
        }
    }
}

// Helper: WrapLayout (简易版)
struct WrapLayout: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        CGSize(width: proposal.width ?? 0, height: 100)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX
        var y = bounds.minY
        
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            
            if x + size.width > bounds.maxX {
                x = bounds.minX
                y += 50
            }
            
            subview.place(at: CGPoint(x: x, y: y), proposal: .unspecified)
            x += size.width + 8
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct RecordView_Previews: PreviewProvider {
    static var previews: some View {
        RecordView()
    }
}
