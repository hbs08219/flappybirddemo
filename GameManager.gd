class_name GameManager
extends Node2D

# 游戏状态
var game_active = false
var score = 0
var high_score = 0

# 引用其他节点
var bird = null
var pipe_spawner = null
var score_label = null
var game_over_label = null

func _ready():
	# 初始化引用
	bird = get_node("/root/BirdContainer/Bird")
	pipe_spawner = get_node("/root/PipeSpawner")
	score_label = get_node("/root/GameUI/ScoreLabel")
	game_over_label = get_node("/root/GameUI/GameOverLabel")
	
	# 连接小鸟的游戏结束信号
	bird.connect("game_over", self, "on_game_over")
	
	# 初始化高分
	# 尝试从存储中加载高分
	# 这里简化处理，实际项目中应使用本地存储
	high_score = 0
	
	# 开始游戏
	start_game()

func start_game():
	# 重置游戏状态
	game_active = true
	score = 0
	
	# 更新UI
	score_label.text = "Score: 0"
	game_over_label.visible = false
	
	# 重置小鸟
	bird.position = Vector2(100, 300)
	bird.velocity = Vector2.ZERO
	bird.game_active = true
	
	# 重置管道生成器
	pipe_spawner.reset()

func on_game_over():
	# 游戏结束逻辑
	game_active = false
	
	# 更新高分
	if score > high_score:
		high_score = score
	
	# 显示游戏结束标签
	game_over_label.visible = true
	game_over_label.text = "Game Over\nScore: " + str(score) + "\nHigh Score: " + str(high_score) + "\nPress Space to Restart"

func update_score(new_score):
	# 更新分数
	score = new_score
	score_label.text = "Score: " + str(score)

func _process(delta):
	# 检查是否需要重启游戏
	if not game_active and Input.is_action_just_pressed("ui_accept"):
		start_game()
	
	# 如果游戏活跃，更新分数
	if game_active:
		# 这里简化处理，实际项目中应该根据小鸟通过管道的数量计算分数
		update_score(int(score + delta * 2))
