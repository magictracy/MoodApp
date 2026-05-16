# MoodTimeline 试运行指南

## 📋 前置准备

### 1. 安装 Xcode（如果尚未安装）

- 从 Mac App Store 下载 Xcode
- 或者从 [developer.apple.com](https://developer.apple.com/download/) 下载
- 预计下载时间：2-4 小时（取决于网络速度）

### 2. 创建 Xcode 项目

由于本项目只有源代码文件，需要手动创建 Xcode 项目：

#### 步骤 1: 创建新项目
1. 打开 Xcode
2. 点击 **File → New → Project**
3. 选择 **iOS → App** 模板
4. 点击 **Next**

#### 步骤 2: 配置项目
- **Product Name**: `MoodTimeline`
- **Team**: 选择您的开发团队（或暂时不选）
- **Organization Identifier**: `com.yourname`（自定义）
- **Interface**: `SwiftUI`
- **Language**: `Swift`
- ✅ **勾选 "Use Core Data"**（虽然现在用内存版，但为将来做准备）
- 点击 **Next**
- 选择保存位置（建议与当前代码同一目录）
- 点击 **Create**

#### 步骤 3: 添加源代码文件
1. 在 Xcode 项目导航器中，右键点击项目文件夹
2. 选择 **Add Files to "MoodTimeline"...**
3. 导航到 `/Users/wenyuan_mac/Documents/2026_project/MoodTimeline`
4. 选择所有 `.swift` 文件和文件夹
5. ✅ 勾选 **Copy items if needed**
6. ✅ 勾选 **Create groups**
7. 点击 **Add**

#### 步骤 4: 清理默认文件
删除 Xcode 自动生成的以下文件（如果存在）：
- `ContentView.swift`（我们使用 MainTabView）
- 默认的 `Persistence.swift`（可选，可以保留作为参考）

#### 步骤 5: 确认入口文件
确保 `MoodTimelineApp.swift` 是应用的入口点：
```swift
@main
struct MoodTimelineApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()  // 确保这里是 MainTabView
        }
    }
}
```

---

## 🚀 运行应用

### 方法 1: 使用模拟器（推荐）

1. 在 Xcode 顶部工具栏，选择目标设备：
   - 点击设备名称下拉菜单
   - 选择一个 iPhone 模拟器（如 iPhone 15 Pro）

2. 点击 **Run** 按钮（▶️）或按 `Cmd + R`

3. 等待编译完成（首次编译可能需要 1-2 分钟）

4. 模拟器会自动启动并运行应用

### 方法 2: 使用真机测试

1. 用 USB 线连接 iPhone 到 Mac
2. 在 Xcode 中选择您的设备
3. 信任设备（如果提示）
4. 点击 **Run** 按钮

---

## ✅ 验证功能

应用启动后，请测试以下功能：

### 1. 时间线页面（默认首页）
- ✅ 应该看到示例数据（2条心情记录）
- ✅ 记录按日期分组显示
- ✅ 可以看到 emoji、时间、备注、强度等信息
- ✅ 右上角有刷新按钮和添加按钮

### 2. 添加心情记录
1. 点击右上角 **+** 按钮或底部 **记录** Tab
2. 选择一个 emoji（如 😊）
3. 调整强度滑块（1-10）
4. 输入触发事件（可选）
5. 输入备注（可选）
6. 选择标签（可多选）
7. 调整身体状态（睡眠、运动、精力）
8. 点击右上角 **保存**
9. ✅ 应该看到保存成功，自动返回时间线
10. ✅ 时间线应该立即显示新记录

### 3. 删除记录
1. 在时间线中找到一条记录
2. 向左滑动该记录
3. 点击 **删除** 按钮
4. ✅ 记录应该被删除，列表自动刷新

### 4. 刷新功能
1. 在时间线页面
2. 点击右上角的 **刷新图标**（箭头圆形）
3. ✅ 列表应该重新加载

### 5. 其他 Tab
- **统计**: 显示"功能开发中..."占位界面
- **设置**: 显示基础设置选项（暂无实际功能）

---

## 🔍 常见问题排查

### 问题 1: 编译错误 "Cannot find 'InMemoryRepository' in scope"

**原因**: 文件未正确添加到项目中

**解决**:
1. 确认 `InMemoryRepository.swift` 已在项目中
2. 检查文件是否在正确的 Target 中：
   - 选中文件
   - 右侧面板 → File Inspector
   - 确保 **Target Membership** 中勾选了 MoodTimeline

### 问题 2: 编译错误 "Cannot find 'DataManager' in scope"

**原因**: 同上，文件未正确添加

**解决**: 确保 `DataManager.swift` 已添加到项目且 Target Membership 正确

### 问题 3: 运行时崩溃 "Fatal error: Unexpectedly found nil"

**原因**: 可能是 CoreData 相关代码仍在引用

**解决**: 
1. 检查 `MoodTimelineApp.swift` 中没有引用 PersistenceController
2. 确认所有地方都使用 `DataManager.shared`

### 问题 4: 时间线显示为空

**原因**: InMemoryRepository 的示例数据未加载

**解决**:
1. 检查控制台输出，看是否有 "✅ InMemoryRepository: Created entry" 日志
2. 确认 `InMemoryRepository.init()` 调用了 `loadSampleData()`

### 问题 5: 新增记录不在时间线显示

**原因**: 数据不同步（不应该发生，因为使用了 DataManager 单例）

**解决**:
1. 点击刷新按钮
2. 检查是否两个页面都使用 `DataManager.shared.moodService`

---

## 📝 控制台日志说明

运行时会看到以下日志，这些都是正常的：

```
✅ InMemoryRepository: Created entry - 😊 at 2026-05-16 10:30:00 +0000
✅ Entry saved successfully
✅ InMemoryRepository: Deleted entry - UUID-HERE
```

这些日志帮助您确认操作是否成功执行。

---

## 🎯 下一步

试运行成功后，您可以：

1. **体验完整功能**: 多添加几条记录，测试各种场景
2. **检查边界情况**: 
   - 不填必填字段（应该无法保存）
   - 删除所有记录（应该显示空状态）
   - 快速连续保存
3. **准备 CoreData 集成**: 
   - 在 Xcode 中打开 `.xcdatamodeld` 文件
   - 创建 `MoodEntry` 和 `Tag` 实体
   - 实现 `MoodRepository` 中的 CoreData 操作
   - 修改 `DataManager.swift` 切换到 CoreData

---

## 💡 提示

- **热重载**: SwiftUI 支持预览，修改代码后模拟器会自动刷新（无需重新编译）
- **调试**: 使用 Xcode 的 Debug Console 查看日志和错误信息
- **性能**: 内存版性能很好，但数据量大时需要考虑 CoreData

祝您试运行顺利！如有问题，请随时告诉我。
