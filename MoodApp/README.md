# MoodApp - 心情时间线 iOS APP

## 项目概述

一款基于 SwiftUI + CoreData 的 iOS 应用,用于按时间线记录和管理日常心情。

## 技术栈

- **UI 框架**: SwiftUI
- **数据持久化**: CoreData
- **最低版本**: iOS 13+
- **开发工具**: Xcode 15+

## 项目结构

```
MoodApp/
├── Models/              # 数据模型
│   └── DTOs/           # 数据传输对象
│       ├── MoodEntryDTO.swift
│       └── TagDTO.swift
├── Services/            # 业务逻辑层
│   ├── MoodRecordService.swift
│   └── DataManager.swift        # 全局数据管理器（单例）
├── Repositories/        # 数据访问层
│   ├── MoodRepository.swift      # CoreData 实现（待完成）
│   └── InMemoryRepository.swift  # 内存版实现（当前使用）
├── Views/               # UI 视图
│   ├── MainTabView.swift
│   ├── Timeline/       # 时间线页面
│   ├── Record/         # 记录页面
│   ├── Analytics/      # 统计页面
│   └── Settings/       # 设置页面
├── ViewModels/          # ViewModel
│   └── RecordViewModel.swift
├── Utilities/           # 工具类
└── Resources/           # 资源文件
```

## 核心功能

### Phase 1: 已完成 ✅
- [x] 项目结构搭建
- [x] DTO 数据模型定义
- [x] Repository 数据访问层（Protocol + InMemory 实现）
- [x] Service 服务层
- [x] 基础 UI 框架
- [x] DataManager 全局数据管理
- [x] 完整的心情记录功能（创建、查看、删除）
- [x] 时间线展示（按日期分组）
- [x] 用户反馈优化（加载状态、错误提示）

### Phase 2: 进行中 🚧
- [ ] CoreData 实体配置 (需要 Xcode)
- [ ] 切换到 CoreData 持久化存储

### Phase 3: 待开发 📋
- [ ] 统计分析功能
- [ ] 图表集成
- [ ] 情绪波动检测

### Phase 4: 待开发 📋
- [ ] 每日提醒功能
- [ ] 数据导出 (CSV/JSON/PDF)

### Phase 5: 待开发 📋
- [ ] iOS 13 兼容性适配
- [ ] 性能优化
- [ ] 测试覆盖

## 重要说明

### 💡 当前状态：内存版数据存储

✅ **应用已可完整运行**，无需等待 Xcode 安装！

当前使用 `InMemoryRepository` 实现，所有数据存储在内存中：
- 可以创建、查看、删除心情记录
- 时间线正确显示所有记录（按日期分组）
- 数据在整个应用中同步（通过 `DataManager.shared`）
- ⚠️ 应用重启后数据会丢失（这是预期行为）

### 🔄 切换到 CoreData

当 Xcode 安装完成后，只需修改 `DataManager.swift` 中的一行代码即可切换到 CoreData 持久化存储，其他所有代码无需修改。这就是 Protocol 抽象层的价值所在。

### ⚠️ Xcode 项目文件需要手动创建

由于 `.xcodeproj` 和 `.xcdatamodeld` 文件需要通过 Xcode GUI 创建,请按照以下步骤操作:

1. 打开 Xcode
2. File → New → Project
3. 选择 "App" 模板
4. 配置:
   - Product Name: `MoodApp`
   - Interface: `SwiftUI`
   - Language: `Swift`
   - ✅ 勾选 "Use Core Data"
5. 将本项目中的源代码文件复制到 Xcode 项目中
6. 在 CoreData Model Editor 中创建 `MoodEntry` 和 `Tag` 实体

## 下一步

继续执行实施计划中的后续任务,完善各功能模块。
