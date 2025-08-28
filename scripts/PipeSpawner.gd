class_name PipeSpawner
extends Node2D

# 游戏参数
const PIPE_SPEED = 200
const PIPE_SPAWN_INTERVAL = 1.5
const PIPE_GAP = 150
const PIPE_Y_OFFSET_RANGE = 100
const SCREEN_WIDTH = 800

# 状态变量
var timer = 0.0
var pipe_scene = null

func _ready():
	# 加载管道场景
	pipe_scene = load("res://scenes/Pipe.tscn")
	# 初始化计时器
	timer = 0.0

func _process(delta):
	# 更新计时器
	timer += delta
	
	# 检查是否需要生成新管道
	if timer >= PIPE_SPAWN_INTERVAL:
		spawn_pipe()
		timer = 0.0
	
	# 移动所有管道
	move_pipes(delta)
	
	# 回收超出屏幕的管道
	recycle_pipes()

func spawn_pipe():
	# 随机生成管道的Y轴偏移
	var y_offset = randf_range(-PIPE_Y_OFFSET_RANGE, PIPE_Y_OFFSET_RANGE)
	
	# 实例化管道场景
	var pipe_instance = pipe_scene.instantiate()
	
	# 设置管道位置（屏幕右侧）
	pipe_instance.position = Vector2(SCREEN_WIDTH + 50, y_offset)
	
	# 将管道添加到当前节点
	add_child(pipe_instance)

func move_pipes(delta):
	# 移动所有管道
	for pipe in get_children():
		pipe.position.x -= PIPE_SPEED * delta

func recycle_pipes():
	# 回收超出屏幕左侧的管道
	for pipe in get_children():
		if pipe.position.x < -100:
			pipe.queue_free()

# 重置管道生成器
func reset():
	# 清除所有管道
	for pipe in get_children():
		pipe.queue_free()
	# 重置计时器
	timer = 0.0
