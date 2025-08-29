@tool
class_name MCPBaseCommandProcessor
extends Node

# Signal emitted when a command has completed processing
signal command_completed(client_id, command_type, result, command_id)

# Reference to the server - passed by the command handler
var _websocket_server = null

# Must be implemented by subclasses
func process_command(client_id: int, command_type: String, params: Dictionary, command_id: String) -> bool:
	push_error("BaseCommandProcessor.process_command called directly")
	return false

# Helper functions common to all command processors
func _send_success(client_id: int, result: Dictionary, command_id: String) -> void:
	var response = {
		"status": "success",
		"result": result
	}
	
	if not command_id.is_empty():
		response["commandId"] = command_id
	
	# Emit the signal for local processing (useful for testing)
	command_completed.emit(client_id, "success", result, command_id)
	
	# Send to websocket if available
	if _websocket_server:
		_websocket_server.send_response(client_id, response)

func _send_error(client_id: int, message: String, command_id: String) -> void:
	var response = {
		"status": "error",
		"message": message
	}
	
	if not command_id.is_empty():
		response["commandId"] = command_id
	
	# Emit the signal for local processing (useful for testing)
	var error_result = {"error": message}
	command_completed.emit(client_id, "error", error_result, command_id)
	
	# Send to websocket if available
	if _websocket_server:
		_websocket_server.send_response(client_id, response)
	print("Error: %s" % message)

# Common utility methods
func _get_editor_node(path: String) -> Node:
	var plugin = Engine.get_meta("GodotMCPPlugin")
	if not plugin:
		print("GodotMCPPlugin not found in Engine metadata")
		return null
		
	var editor_interface = plugin.get_editor_interface()
	var edited_scene_root = editor_interface.get_edited_scene_root()
	
	if not edited_scene_root:
		print("No edited scene found")
		return null
		
	# Handle absolute paths
	if path == "/root" or path == "":
		return edited_scene_root
		
	if path.begins_with("/root/"):
		path = path.substr(6)  # Remove "/root/"
	elif path.begins_with("/"):
		path = path.substr(1)  # Remove leading "/"
	
	# Try to find node as child of edited scene root
	return edited_scene_root.get_node_or_null(path)

# Helper function to mark a scene as modified
func _mark_scene_modified() -> void:
	var plugin = Engine.get_meta("GodotMCPPlugin")
	if not plugin:
		print("GodotMCPPlugin not found in Engine metadata")
		return
	
	var editor_interface = plugin.get_editor_interface()
	var edited_scene_root = editor_interface.get_edited_scene_root()
	
	if edited_scene_root:
		# 使用正确的Godot 4.x API来标记场景为已修改
		# 方法1：尝试使用新的API
		if editor_interface.has_method("mark_scene_as_unsaved"):
			editor_interface.mark_scene_as_unsaved()
		# 方法2：尝试使用资源修改标记
		elif edited_scene_root.has_method("set_edited"):
			edited_scene_root.set_edited(true)
		# 方法3：强制触发编辑器更新
		else:
			# 通过修改节点来触发编辑器更新
			var temp_property = edited_scene_root.get("name")
			edited_scene_root.set("name", temp_property)
			edited_scene_root.set("name", temp_property)
		
		print("Scene marked as modified")
		
		# 尝试强制保存场景
		_force_scene_save(editor_interface, edited_scene_root)
	else:
		print("No edited scene found to mark as modified")

# 新增：强制保存场景的函数
func _force_scene_save(editor_interface, edited_scene_root) -> void:
	# 尝试使用编辑器的保存机制
	if editor_interface.has_method("save_scene"):
		var result = editor_interface.save_scene()
		if result == OK:
			print("Scene saved successfully")
		else:
			print("Failed to save scene, result: ", result)
	elif editor_interface.has_method("save_current_scene"):
		var result = editor_interface.save_current_scene()
		if result == OK:
			print("Current scene saved successfully")
		else:
			print("Failed to save current scene, result: ", result)
	else:
		print("No save method available on editor interface")
		
		# 备用方案：手动保存场景文件
		var scene_path = edited_scene_root.scene_file_path
		if scene_path and scene_path != "":
			var packed_scene = PackedScene.new()
			var result = packed_scene.pack(edited_scene_root)
			if result == OK:
				var save_result = ResourceSaver.save(packed_scene, scene_path)
				if save_result == OK:
					print("Scene manually saved to: ", scene_path)
				else:
					print("Failed to manually save scene, error: ", save_result)
			else:
				print("Failed to pack scene, error: ", result)
		else:
			print("Scene has no file path, cannot save")

# Helper function to access the EditorUndoRedoManager
func _get_undo_redo():
	var plugin = Engine.get_meta("GodotMCPPlugin")
	if not plugin or not plugin.has_method("get_undo_redo"):
		print("Cannot access UndoRedo from plugin")
		return null
		
	return plugin.get_undo_redo()

# Helper function to parse property values from string to proper Godot types
func _parse_property_value(value):
	# 处理资源路径字符串
	if typeof(value) == TYPE_STRING and value.begins_with("res://"):
		print("Detected resource path: %s" % value)
		return _load_resource_from_path(value)
	
	# Only try to parse strings that look like they could be Godot types
	if typeof(value) == TYPE_STRING and (
		value.begins_with("Vector") or 
		value.begins_with("Transform") or 
		value.begins_with("Rect") or 
		value.begins_with("Color") or
		value.begins_with("Quat") or
		value.begins_with("Basis") or
		value.begins_with("Plane") or
		value.begins_with("AABB") or
		value.begins_with("Projection") or
		value.begins_with("Callable") or
		value.begins_with("Signal") or
		value.begins_with("PackedVector") or
		value.begins_with("PackedString") or
		value.begins_with("PackedFloat") or
		value.begins_with("PackedInt") or
		value.begins_with("PackedColor") or
		value.begins_with("PackedByteArray") or
		value.begins_with("Dictionary") or
		value.begins_with("Array")
	):
		var expression = Expression.new()
		var error = expression.parse(value, [])
		
		if error == OK:
			var result = expression.execute([], null, true)
			if not expression.has_execute_failed():
				print("Successfully parsed %s as %s" % [value, result])
				return result
			else:
				print("Failed to execute expression for: %s" % value)
		else:
			print("Failed to parse expression: %s (Error: %d)" % [value, error])
	
	# Otherwise, return value as is
	return value

# 新增：从路径加载资源的函数
func _load_resource_from_path(path: String):
	print("Attempting to load resource from path: %s" % path)
	
	# 检查文件是否存在
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		print("ERROR: File does not exist or cannot be accessed: %s" % path)
		return null
	file.close()
	
	# 根据文件扩展名智能加载资源
	var extension = path.get_extension().to_lower()
	var resource = null
	
	match extension:
		"png", "jpg", "jpeg", "webp", "tga", "bmp":
			print("Loading texture from: %s" % path)
			resource = load(path)
			if resource:
				print("Successfully loaded texture: %s" % resource)
			else:
				print("Failed to load texture from: %s" % path)
		
		"ogg", "wav", "mp3", "flac":
			print("Loading audio from: %s" % path)
			resource = load(path)
			if resource:
				print("Successfully loaded audio: %s" % resource)
			else:
				print("Failed to load audio from: %s" % path)
		
		"ttf", "otf":
			print("Loading font from: %s" % path)
			resource = load(path)
			if resource:
				print("Successfully loaded font: %s" % resource)
			else:
				print("Failed to load font from: %s" % path)
		
		"tscn", "scn":
			print("Loading scene from: %s" % path)
			resource = load(path)
			if resource:
				print("Successfully loaded scene: %s" % resource)
			else:
				print("Failed to load scene from: %s" % path)
		
		"tres", "res":
			print("Loading resource from: %s" % path)
			resource = load(path)
			if resource:
				print("Successfully loaded resource: %s" % resource)
			else:
				print("Failed to load resource from: %s" % path)
		
		_:
			print("Unknown file extension: %s, attempting generic load" % extension)
			resource = load(path)
			if resource:
				print("Successfully loaded resource with unknown extension: %s" % resource)
			else:
				print("Failed to load resource with unknown extension: %s" % path)
	
	if resource:
		print("Resource loaded successfully: %s (Type: %s)" % [resource, resource.get_class()])
		return resource
	else:
		print("ERROR: Failed to load resource from path: %s" % path)
		return null
