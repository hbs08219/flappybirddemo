extends Node2D

# 游戏状态枚举
enum GameState {
	MENU,      # 主菜单
	PLAYING,   # 游戏中
	PAUSED,    # 暂停
	GAME_OVER  # 游戏结束
}

# 游戏配置
@export var gravity: float = 800.0
@export var jump_force: float = -400.0
@export var pipe_speed: float = 200.0
@export var pipe_spawn_time: float = 2.0
@export var pipe_gap: float = 200.0

# 游戏状态
var current_state: GameState = GameState.MENU
var score: int = 0
var high_score: int = 0

# 节点引用
@onready var bird: CharacterBody2D = $"../Bird"
@onready var pipe_spawner: Node2D = $"../PipeSpawner"
@onready var ui_manager: CanvasLayer = $"../UIManager"
@onready var background_manager: Node2D = $"../BackgroundManager"

func _ready():
	# 初始化游戏
	randomize()
	load_high_score()
	setup_game()
	
func setup_game():
	# 设置游戏初始状态
	current_state = GameState.MENU
	score = 0
	if ui_manager:
		ui_manager.show_menu()
	
func start_game():
	# 开始游戏
	current_state = GameState.PLAYING
	score = 0
	if bird and bird.has_method("reset_bird"):
		bird.reset_bird()
	if pipe_spawner and pipe_spawner.has_method("start_spawning"):
		pipe_spawner.start_spawning()
	if ui_manager:
		ui_manager.show_game_ui()
		ui_manager.update_score(score)
	
func pause_game():
	# 暂停游戏
	if current_state == GameState.PLAYING:
		current_state = GameState.PAUSED
		get_tree().paused = true
		if ui_manager:
			ui_manager.show_pause_menu()
		
func resume_game():
	# 恢复游戏
	if current_state == GameState.PAUSED:
		current_state = GameState.PLAYING
		get_tree().paused = false
		if ui_manager:
			ui_manager.hide_pause_menu()
		
func game_over():
	# 游戏结束
	current_state = GameState.GAME_OVER
	if pipe_spawner and pipe_spawner.has_method("stop_spawning"):
		pipe_spawner.stop_spawning()
	
	# 更新最高分
	if score > high_score:
		high_score = score
		save_high_score()
	
	if ui_manager:
		ui_manager.show_game_over(score, high_score)
	
func add_score():
	# 增加分数
	score += 1
	if ui_manager:
		ui_manager.update_score(score)
	
func restart_game():
	# 重新开始游戏
	if pipe_spawner and pipe_spawner.has_method("clear_pipes"):
		pipe_spawner.clear_pipes()
	# 重新开始
	start_game()
	
func _input(event):
	# 输入处理
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_select"):
		match current_state:
			GameState.MENU:
				start_game()
			GameState.PLAYING:
				if bird and bird.has_method("jump"):
					bird.jump()
			GameState.GAME_OVER:
				restart_game()
	
	# ESC键暂停/恢复
	if event.is_action_pressed("ui_cancel"):
		match current_state:
			GameState.PLAYING:
				pause_game()
			GameState.PAUSED:
				resume_game()
				
func load_high_score():
	# 加载最高分
	if FileAccess.file_exists("user://highscore.save"):
		var file = FileAccess.open("user://highscore.save", FileAccess.READ)
		high_score = file.get_var()
		file.close()
		
func save_high_score():
	# 保存最高分
	var file = FileAccess.open("user://highscore.save", FileAccess.WRITE)
	file.store_var(high_score)
	file.close()
