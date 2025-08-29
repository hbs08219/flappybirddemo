extends CharacterBody2D

# 小鸟属性
@export var gravity: float = 800.0
@export var jump_force: float = -400.0
@export var max_fall_speed: float = 400.0

# 节点引用
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

# 小鸟状态
var is_alive: bool = true
var initial_position: Vector2

func _ready():
	# 初始化小鸟
	initial_position = Vector2(576, 324)  # 使用固定的屏幕中心位置
	setup_bird()
	
func setup_bird():
	# 设置小鸟初始状态
	velocity = Vector2.ZERO
	position = initial_position
	is_alive = true
	
func _physics_process(delta):
	if not is_alive:
		return
		
	# 应用重力
	velocity.y += gravity * delta
	
	# 限制下落速度
	if velocity.y > max_fall_speed:
		velocity.y = max_fall_speed
	
	# 更新小鸟旋转（根据速度）
	update_rotation()
	
	# 移动小鸟
	move_and_slide()
	
	# 检查是否掉出屏幕
	check_bounds()
	
func jump():
	if not is_alive:
		return
		
	# 跳跃
	velocity.y = jump_force
	
func update_rotation():
	# 根据速度更新小鸟旋转
	if sprite:
		var target_rotation = clamp(velocity.y / 400.0, -0.5, 0.5)
		sprite.rotation = lerp(sprite.rotation, target_rotation, 0.1)
	
func check_bounds():
	# 检查小鸟是否掉出屏幕
	if position.y > 600 or position.y < -100:
		die()
		
func die():
	# 小鸟死亡
	if not is_alive:
		return
		
	is_alive = false
	velocity = Vector2.ZERO
	
	# 通知游戏管理器
	var game_manager = get_parent()
	if game_manager and game_manager.has_method("game_over"):
		game_manager.game_over()
		
func reset_bird():
	# 重置小鸟
	setup_bird()
	
func _on_area_2d_body_entered(body):
	# 碰撞检测
	if body.is_in_group("pipes") and is_alive:
		die()
	elif body.is_in_group("score_zone") and is_alive:
		# 通过管道得分
		var game_manager = get_parent()
		if game_manager and game_manager.has_method("add_score"):
			game_manager.add_score()
