@tool
extends Control

var websocket_server  # 动态类型以兼容 EditorPlugin 作为服务器实例
var status_label: Label
var port_input: SpinBox
var start_button: Button
var stop_button: Button
var connection_count_label: Label
var log_text: TextEdit

func _ready():
	status_label = $VBoxContainer/StatusContainer/StatusLabel
	port_input = $VBoxContainer/PortContainer/PortSpinBox
	start_button = $VBoxContainer/ButtonsContainer/StartButton
	stop_button = $VBoxContainer/ButtonsContainer/StopButton
	connection_count_label = $VBoxContainer/ConnectionsContainer/CountLabel
	log_text = $VBoxContainer/LogContainer/LogText
	
	start_button.pressed.connect(_on_start_button_pressed)
	stop_button.pressed.connect(_on_stop_button_pressed)
	port_input.value_changed.connect(_on_port_changed)
	
	# Initial UI setup
	_update_ui()
	
	# Set MCP panel reference in the plugin
	await get_tree().process_frame
	var plugin = Engine.get_meta("GodotMCPPlugin")
	if plugin and plugin.has_method("set_mcp_panel"):
		plugin.set_mcp_panel(self)
		print("MCP panel reference set in plugin")
	
	# Setup server signals once it's available
	if websocket_server:
		if websocket_server.has_method("connect"):
			websocket_server.connect("client_connected", Callable(self, "_on_client_connected"))
			websocket_server.connect("client_disconnected", Callable(self, "_on_client_disconnected"))
			websocket_server.connect("command_received", Callable(self, "_on_command_received"))
		if websocket_server.has_method("get_port"):
			port_input.value = websocket_server.get_port()

func _update_ui():
	if not websocket_server:
		status_label.text = "Server: Not initialized"
		start_button.disabled = true
		stop_button.disabled = true
		port_input.editable = true
		connection_count_label.text = "0"
		return
	
	var is_active := false
	if websocket_server.has_method("is_server_active"):
		is_active = websocket_server.is_server_active()
	
	status_label.text = "Server: " + ("Running" if is_active else "Stopped")
	start_button.disabled = is_active
	stop_button.disabled = not is_active
	port_input.editable = not is_active
	
	if is_active and websocket_server.has_method("get_client_count"):
		connection_count_label.text = str(websocket_server.get_client_count())
	else:
		connection_count_label.text = "0"

func _on_start_button_pressed():
	if websocket_server and websocket_server.has_method("start_server"):
		var result = websocket_server.start_server()
		if result == OK:
			_log_message("Server started on port " + (str(websocket_server.get_port()) if websocket_server.has_method("get_port") else ""))
		else:
			_log_message("Failed to start server: " + str(result))
		_update_ui()

func _on_stop_button_pressed():
	if websocket_server and websocket_server.has_method("stop_server"):
		websocket_server.stop_server()
		_log_message("Server stopped")
		_update_ui()

func _on_port_changed(new_port: float):
	if websocket_server and websocket_server.has_method("set_port"):
		websocket_server.set_port(int(new_port))
		_log_message("Port changed to " + str(int(new_port)))

func _on_client_connected(client_id: int):
	_log_message("Client connected: " + str(client_id))
	_update_ui()

func _on_client_disconnected(client_id: int):
	_log_message("Client disconnected: " + str(client_id))
	_update_ui()

func _on_command_received(client_id: int, command: Dictionary):
	var command_type = command.get("type", "unknown")
	var command_id = command.get("commandId", "no-id")
	_log_message("Received command: " + command_type + " (ID: " + command_id + ") from client " + str(client_id))

func _log_message(message: String) -> void:
	var timestamp = Time.get_datetime_string_from_system(true)
	var line: String = "[" + timestamp + "] " + message
	log_text.text += line + "\n"
	# 滚动到末尾
	var last_line: int = max(0, log_text.get_line_count() - 1)
	if log_text.has_method("set_caret_line"):
		log_text.set_caret_line(last_line)
	# 写入插件持久缓冲
	var plugin = Engine.get_meta("GodotMCPPlugin")
	if plugin and plugin.has_method("append_log"):
		plugin.append_log(line)

func clear_logs() -> void:
	"""Clear all logs from the panel"""
	log_text.text = ""

func get_log_text() -> String:
	"""Get the current log text content"""
	return log_text.text