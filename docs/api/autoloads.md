# 自动加载节点接口

## 概述
本项目使用了以下自动加载节点（Autoload）来实现全局功能和状态管理。

## GameManager

### 功能概述
游戏管理器，负责全局游戏状态管理、分数计算和游戏流程控制。

### 核心属性
- `game_state`: 游戏当前状态（准备、运行、结束）
- `score`: 当前分数
- `high_score`: 最高分
- `is_game_over`: 游戏是否结束

### 常用方法
- `start_game()` -> void: 开始游戏
- `on_game_over()` -> void: 处理游戏结束逻辑
- `update_score(amount: int)` -> void: 更新分数
- `reset_game()` -> void: 重置游戏状态

### 信号
- `game_started`: 游戏开始时触发
- `game_over`: 游戏结束时触发
- `score_updated(score: int)`: 分数更新时触发

## 如何访问
```gdscript
# 在任何脚本中访问
GameManager.start_game()
print("当前分数: ", GameManager.score)
```