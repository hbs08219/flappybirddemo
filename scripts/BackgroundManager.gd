extends Node2D

# 背景配置
@export var scroll_speed: float = 100.0
@export var background_count: int = 2

# 背景节点
var backgrounds: Array[Sprite2D] = []
var background_width: float = 800.0

func _ready():
	# 创建背景
	create_backgrounds()
	
func create_backgrounds():
	# 创建多个背景以实现无缝滚动
	for i in range(background_count):
		var background = Sprite2D.new()
		background.name = "Background" + str(i)
		
		# 创建简单的背景（可以用图片替换）
		var texture = create_background_texture()
		background.texture = texture
		
		# 设置位置
		background.position.x = i * background_width
		background.position.y = 300
		
		add_child(background)
		backgrounds.append(background)
		
func create_background_texture():
	# 创建简单的背景纹理
	var image = Image.create(800, 600, false, Image.FORMAT_RGBA8)
	
	# 填充天空蓝色
	image.fill(Color(0.5, 0.8, 1.0, 1.0))
	
	# 添加地面
	for x in range(800):
		for y in range(500, 600):
			image.set_pixel(x, y, Color(0.6, 0.4, 0.2, 1.0))
	
	var texture = ImageTexture.create_from_image(image)
	return texture
				
func _process(delta):
	# 滚动背景
	scroll_backgrounds(delta)
	
func scroll_backgrounds(delta):
	# 移动所有背景
	for background in backgrounds:
		background.position.x -= scroll_speed * delta
		
		# 如果背景移出屏幕左侧，移动到右侧
		if background.position.x < -background_width:
			background.position.x += background_count * background_width
