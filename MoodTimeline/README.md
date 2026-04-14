# MoodTimeline - 心情时间线 iOS APP

## 项目概述

一款基于 SwiftUI + CoreData 的 iOS 应用,用于按时间线记录和管理日常心情。

## 技术栈

- **UI 框架**: SwiftUI
- **数据持久化**: CoreData
- **最低版本**: iOS 13+
- **开发工具**: Xcode 15+

## 项目结构

```
MoodTimeline/
├── Models/              # 数据模型
│   └── DTOs/           # 数据传输对象
│       ├── MoodEntryDTO.swift
│       └── TagDTO.swift
├── Services/            # 业务逻辑层
│   └── MoodRecordService.swift
├── Repositories/        # 数据访问层
│   └── MoodRepository.swift
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
- [x] Repository 数据访问层
- [x] Service 服务层
- [x] 基础 UI 框架

### Phase 2: 进行中 🚧
- [ ] CoreData 实体配置 (需要 Xcode)
- [ ] 完整的时间线展示
- [ ] 完整的记录表单

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

⚠️ **Xcode 项目文件需要手动创建**

由于 `.xcodeproj` 和 `.xcdatamodeld` 文件需要通过 Xcode GUI 创建,请按照以下步骤操作:

1. 打开 Xcode
2. File → New → Project
3. 选择 "App" 模板
4. 配置:
   - Product Name: `MoodTimeline`
   - Interface: `SwiftUI`
   - Language: `Swift`
   - ✅ 勾选 "Use Core Data"
5. 将本项目中的源代码文件复制到 Xcode 项目中
6. 在 CoreData Model Editor 中创建 `MoodEntry` 和 `Tag` 实体

## 下一步

继续执行实施计划中的后续任务,完善各功能模块。
