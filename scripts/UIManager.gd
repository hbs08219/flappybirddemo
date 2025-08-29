extends CanvasLayer

# UI节点引用
@onready var menu_panel: Panel = $MenuPanel
@onready var game_ui: Control = $GameUI
@onready var pause_panel: Panel = $PausePanel
@onready var game_over_panel: Panel = $GameOverPanel
@onready var score_label: Label = $GameUI/ScoreLabel
@onready var high_score_label: Label = $GameUI/HighScoreLabel
@onready var final_score_label: Label = $GameOverPanel/VBoxContainer/FinalScoreLabel
@onready var final_high_score_label: Label = $GameOverPanel/VBoxContainer/FinalHighScoreLabel

# 按钮引用
@onready var start_button: Button = $MenuPanel/VBoxContainer/StartButton
@onready var pause_resume_button: Button = $PausePanel/VBoxContainer/ResumeButton
@onready var restart_button: Button = $GameOverPanel/VBoxContainer/RestartButton
@onready var menu_button: Button = $GameOverPanel/VBoxContainer/MenuButton

func _ready():
	# 初始化UI
	setup_ui()
	connect_signals()
	show_menu()
	
func setup_ui():
	# 设置UI初始状态
	if menu_panel:
		menu_panel.visible = false
	if game_ui:
		game_ui.visible = false
	if pause_panel:
		pause_panel.visible = false
	if game_over_panel:
		game_over_panel.visible = false
	
func connect_signals():
	# 连接按钮信号
	if start_button:
		start_button.pressed.connect(_on_start_button_pressed)
	if pause_resume_button:
		pause_resume_button.pressed.connect(_on_resume_button_pressed)
	if restart_button:
		restart_button.pressed.connect(_on_restart_button_pressed)
	if menu_button:
		menu_button.pressed.connect(_on_menu_button_pressed)
		
func show_menu():
	# 显示主菜单
	if menu_panel:
		menu_panel.visible = true
	if game_ui:
		game_ui.visible = false
	if pause_panel:
		pause_panel.visible = false
	if game_over_panel:
		game_over_panel.visible = false
	
func show_game_ui():
	# 显示游戏UI
	if menu_panel:
		menu_panel.visible = false
	if game_ui:
		game_ui.visible = true
	if pause_panel:
		pause_panel.visible = false
	if game_over_panel:
		game_over_panel.visible = false
	
func show_pause_menu():
	# 显示暂停菜单
	if pause_panel:
		pause_panel.visible = true
	
func hide_pause_menu():
	# 隐藏暂停菜单
	if pause_panel:
		pause_panel.visible = false
	
func show_game_over(final_score: int, final_high_score: int):
	# 显示游戏结束界面
	if menu_panel:
		menu_panel.visible = false
	if game_ui:
		game_ui.visible = false
	if pause_panel:
		pause_panel.visible = false
	if game_over_panel:
		game_over_panel.visible = true
	
	# 更新分数显示
	if final_score_label:
		final_score_label.text = "Score: " + str(final_score)
	if final_high_score_label:
		final_high_score_label.text = "High Score: " + str(final_high_score)
		
func update_score(new_score: int):
	# 更新分数显示
	if score_label:
		score_label.text = "Score: " + str(new_score)
		
func update_high_score(new_high_score: int):
	# 更新最高分显示
	if high_score_label:
		high_score_label.text = "High Score: " + str(new_high_score)
		
# 按钮事件处理
func _on_start_button_pressed():
	var game_manager = get_parent()
	if game_manager and game_manager.has_method("start_game"):
		game_manager.start_game()
		
func _on_resume_button_pressed():
	var game_manager = get_parent()
	if game_manager and game_manager.has_method("resume_game"):
		game_manager.resume_game()
		
func _on_restart_button_pressed():
	var game_manager = get_parent()
	if game_manager and game_manager.has_method("restart_game"):
		game_manager.restart_game()
		
func _on_menu_button_pressed():
	var game_manager = get_parent()
	if game_manager and game_manager.has_method("setup_game"):
		game_manager.setup_game()
