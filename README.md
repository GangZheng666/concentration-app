# 专注时间排名应用 🎯

一款帮助你提升专注力的跨平台应用，通过专注计时和成就系统激励你保持专注习惯。

## ✨ 功能特性

### 核心功能
- ⏱️ **专注计时** - 支持 15/25/45/60/90 分钟多种时长
- 🏆 **排行榜系统** - 查看专注时间排名
- 🎊 **成就系统** - 18 个成就等待解锁
- 📈 **等级系统** - 专注时长转化为经验值升级
- 🔥 **连续打卡** - 记录连续专注天数

### 成就类型
| 类型 | 成就 |
|------|------|
| 📅 专注次数 | 初次专注、专注达人、专注王者、专注传奇 |
| ⏰ 累计时长 | 一小时战士、十小时大师、五十小时传奇、百小时神话 |
| 🔥 连续天数 | 三天连续、一周坚持、月度坚持 |
| ⭐ 等级成就 | 初露锋芒、小有所成、高手风范、巅峰之作 |
| 🎮 特殊成就 | 专注马拉松、早起鸟、深夜加班 |

## 🛠️ 技术栈

- **框架**: Flutter 3.19.3
- **语言**: Dart 3.3.1
- **状态管理**: Provider
- **数据存储**: SharedPreferences
- **UI**: Material Design 3

## 📱 支持平台

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🚀 快速开始

### 环境要求

- Flutter SDK 3.19.0+
- Dart SDK 3.3.0+

### 安装依赖

```bash
flutter pub get
```

### 运行应用

```bash
# Web
flutter run -d chrome

# Android
flutter run -d android

# iOS
flutter run -d ios

# Windows
flutter run -d windows
```

### 构建发布版本

```bash
# Android APK
flutter build apk

# iOS (需要 macOS)
flutter build ios

# Web
flutter build web

# Windows
flutter build windows
```

## 📁 项目结构

```
lib/
├── main.dart                    # 应用入口
├── models/                      # 数据模型
│   ├── user.dart               # 用户模型
│   ├── focus_session.dart      # 专注会话模型
│   └── achievement.dart        # 成就模型
├── providers/
│   └── app_state.dart          # 全局状态管理
├── screens/                     # 页面组件
│   ├── home_screen.dart        # 主页导航
│   ├── focus_screen.dart       # 专注计时页面
│   ├── leaderboard_screen.dart # 排行榜页面
│   ├── achievements_screen.dart # 成就页面
│   └── profile_screen.dart     # 个人资料页面
├── services/                   # 服务层
│   ├── database_service.dart   # 数据库服务
│   └── achievement_checker.dart # 成就检查器
└── widgets/                    # 通用组件
    ├── timer_display.dart      # 计时器组件
    └── user_rank_card.dart     # 用户排名卡片
```

## 🎮 使用说明

1. **创建用户**: 进入「我的」页面，设置名字和选择头像
2. **开始专注**: 在「专注」页面选择时长，点击开始按钮
3. **完成专注**: 计时结束后自动记录专注时间
4. **查看成就**: 在「成就」页面查看已解锁和未解锁的成就
5. **查看排名**: 在「排行」页面查看专注时间排行榜

## 🔄 数据同步

当前版本数据存储在本地，支持：
- Web: localStorage
- Mobile: SharedPreferences
- Desktop: SharedPreferences

> **提示**: 如需多设备同步和真实排行榜，需要部署后端服务。

## 📄 开源协议

MIT License

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

---

**专注每一天，成就更好的自己！** 💪
