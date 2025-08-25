# 移除 class_name 声明以避免隐藏全局脚本类
extends CharacterBody2D

# 游戏参数
const GRAVITY = 980
const JUMP_FORCE = -300
const MAX_ROTATION = 30  # 最大旋转角度（度）
const MIN_ROTATION = -60  # 最小旋转角度（度）
const ROTATION_SPEED = 5  # 旋转速度

# 状态变量
var game_active = true

signal game_over

func _ready():
	# 设置初始位置
	position = Vector2(100, 300)
	# 初始化速度
	velocity = Vector2.ZERO

func _process(delta):
	if not game_active:
		return
	
	# 处理输入（空格或鼠标点击跳跃）
	if Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		jump()
	
	# 应用重力
	velocity.y += GRAVITY * delta
	
	# 更新位置
	move_and_slide()
	
	# 更新旋转
	update_rotation()
	
	# 检查是否碰撞
	if is_on_wall() or position.y > get_viewport_rect().size.y + 50:
		on_game_over()
func jump():
	# 跳跃
	velocity.y = JUMP_FORCE
	# 播放跳跃音效（如果有）
	# $JumpSound.play()

func update_rotation():
	# 根据速度更新旋转角度
	var rotation_angle = clamp(velocity.y / 10, MIN_ROTATION, MAX_ROTATION)
	rotation = deg_to_rad(rotation_angle)

func on_game_over():
	# 游戏结束逻辑
	game_active = false
	# 停止移动
	velocity = Vector2.ZERO
	# 发送游戏结束信号
	emit_signal("game_over")
	# 可以在这里添加游戏结束动画或效果
