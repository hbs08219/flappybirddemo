# 组件接口说明

## 概述
本项目包含以下可复用组件，用于构建游戏功能。

## BirdController

### 功能概述
控制小鸟的运动、输入响应和动画播放。

### 核心属性
- `jump_force`: 跳跃力度
- `gravity`: 重力加速度
- `max_rotation`: 最大旋转角度
- `min_rotation`: 最小旋转角度

### 常用方法
- `_ready()` -> void: 初始化方法
- `_process(delta: float)` -> void: 每帧更新方法
- `_input(event: InputEvent)` -> void: 输入处理方法
- `jump()` -> void: 小鸟跳跃方法
- `die()` -> void: 小鸟死亡处理方法

### 信号
- `bird_hit`: 小鸟碰撞时触发

## PipeSpawner

### 功能概述
负责水管的生成、移动和回收。

### 核心属性
- `pipe_speed`: 水管移动速度
- `spawn_interval`: 水管生成间隔
- `pipe_gap`: 水管间隙大小
- `pipe_scene`: 水管场景资源

### 常用方法
- `_ready()` -> void: 初始化方法
- `_process(delta: float)` -> void: 每帧更新方法
- `spawn_pipe()` -> void: 生成水管方法
- `move_pipes(delta: float)` -> void: 移动水管方法
- `recycle_pipes()` -> void: 回收水管方法
- `reset()` -> void: 重置方法

### 信号
- `pipe_passed`: 小鸟通过水管时触发

## 使用示例
```gdscript
# 创建小鸟控制器实例
var bird_controller = BirdController.new()
# 设置跳跃力度
bird_controller.jump_force = 300
# 监听碰撞信号
bird_controller.connect("bird_hit", self, "on_bird_hit")

# 创建水管生成器实例
var pipe_spawner = PipeSpawner.new()
# 设置水管速度
pipe_spawner.pipe_speed = 200
# 监听通过水管信号
pipe_spawner.connect("pipe_passed", self, "on_pipe_passed")
```