extends Node2D

# 管道预制体
@export var pipe_scene: PackedScene
@export var pipe_speed: float = 200.0
@export var pipe_spawn_time: float = 2.0
@export var pipe_gap: float = 200.0
@export var min_pipe_height: float = 100.0
@export var max_pipe_height: float = 400.0

# 生成器状态
var is_spawning: bool = false
var spawn_timer: float = 0.0
var pipes: Array[Node2D] = []

# 节点引用
@onready var spawn_position: Marker2D = $SpawnPosition

func _ready():
	# 初始化生成器
	if not pipe_scene:
		print("Warning: No pipe scene set for PipeSpawner")
		
func _process(delta):
	if not is_spawning:
		return
		
	# 更新生成计时器
	spawn_timer -= delta
	if spawn_timer <= 0:
		spawn_pipe()
		spawn_timer = pipe_spawn_time
		
	# 移动和清理管道
	update_pipes(delta)
	
func start_spawning():
	# 开始生成管道
	is_spawning = true
	spawn_timer = pipe_spawn_time
	print("Pipe spawning started")
	
func stop_spawning():
	# 停止生成管道
	is_spawning = false
	print("Pipe spawning stopped")
	
func spawn_pipe():
	# 生成新管道
	if not pipe_scene:
		print("Error: Cannot spawn pipe - no pipe scene set")
		return
		
	var pipe = pipe_scene.instantiate()
	add_child(pipe)
	pipes.append(pipe)
	
	# 设置管道位置
	pipe.position = spawn_position.position
	print("Pipe spawned at: ", pipe.position)
	
func update_pipes(delta):
	# 更新所有管道位置
	for i in range(pipes.size() - 1, -1, -1):
		var pipe = pipes[i]
		if pipe:
			# 移动管道
			pipe.position.x -= pipe_speed * delta
			
			# 检查是否超出屏幕
			if pipe.position.x < -200:
				pipe.queue_free()
				pipes.remove_at(i)
				
func clear_pipes():
	# 清除所有管道
	for pipe in pipes:
		if pipe:
			pipe.queue_free()
	pipes.clear()
	print("All pipes cleared")
