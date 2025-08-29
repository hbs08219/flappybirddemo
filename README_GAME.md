# 🐦 FlappyBird 游戏

一个使用 Godot 4.5 引擎开发的经典 FlappyBird 游戏！

## 🎮 游戏特色

- **经典玩法**：控制小鸟穿过管道，挑战你的反应能力
- **流畅控制**：精确的物理系统和响应式控制
- **完整UI**：主菜单、游戏界面、暂停和游戏结束界面
- **分数系统**：记录当前分数和最高分
- **自动保存**：游戏进度和最高分自动保存

## 🎯 游戏目标

控制小鸟在管道之间飞行，每通过一个管道得1分。避免撞到管道或掉出屏幕，挑战你的最高分！

## ⌨️ 操作方法

- **空格键 / 回车键 / 鼠标点击**：小鸟跳跃
- **ESC键**：暂停/恢复游戏
- **游戏结束后**：按任意键重新开始

## 🏗️ 技术架构

### 核心组件
- **GameManager**：游戏状态管理和逻辑控制
- **BirdController**：小鸟物理控制和碰撞检测
- **PipeSpawner**：管道生成和移动管理
- **UIManager**：用户界面和交互管理
- **BackgroundManager**：背景滚动和视觉效果

### 场景结构
```
MainScene.tscn (主场景)
├── GameManager (游戏管理器)
├── Bird (小鸟)
├── PipeSpawner (管道生成器)
├── UIManager (UI管理器)
└── BackgroundManager (背景管理器)
```

### 资源文件
- `小鸟.png`：主角小鸟精灵
- `水管.png`：障碍物管道

## 🚀 如何运行

1. **启动项目**：运行 `run_flappybird.bat` 或 `run_flappybird.ps1`
2. **等待加载**：Godot编辑器会自动打开项目
3. **开始游戏**：点击"Start Game"按钮或按空格键
4. **享受游戏**：控制小鸟穿越管道，挑战高分！

## 🛠️ 开发说明

### 脚本文件
- `scripts/GameManager.gd`：主游戏逻辑
- `scripts/BirdController.gd`：小鸟控制
- `scripts/PipeSpawner.gd`：管道系统
- `scripts/UIManager.gd`：界面管理
- `scripts/BackgroundManager.gd`：背景效果

### 场景文件
- `scenes/MainScene.tscn`：主游戏场景
- `scenes/Bird.tscn`：小鸟场景
- `scenes/Pipe.tscn`：管道场景

### 自定义配置
- 重力：800.0
- 跳跃力度：-400.0
- 管道速度：200.0
- 管道间距：200.0
- 管道生成时间：2.0秒

## 🎨 扩展建议

- 添加音效和背景音乐
- 实现多种小鸟皮肤
- 添加特效和粒子系统
- 实现成就系统
- 添加移动端触摸支持

## 📝 更新日志

### v1.0.0 (2025-01-14)
- ✅ 基础游戏功能实现
- ✅ 完整的UI系统
- ✅ 物理和碰撞系统
- ✅ 分数记录系统
- ✅ 自动保存功能

---

**享受游戏，挑战高分！** 🎉
