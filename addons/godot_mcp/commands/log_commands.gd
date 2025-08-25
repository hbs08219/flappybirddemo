@tool
class_name MCPServerLogCommands
extends MCPBaseCommandProcessor

func process_command(client_id: int, command_type: String, params: Dictionary, command_id: String) -> bool:
	match command_type:
		"get_server_logs":
			_get_server_logs(client_id, params, command_id)
			return true
		"clear_server_logs":
			_clear_server_logs(client_id, params, command_id)
			return true
	return false  # Command not handled

func _get_server_logs(client_id: int, params: Dictionary, command_id: String) -> void:
	# Get editor plugin and interfaces
	var plugin = Engine.get_meta("GodotMCPPlugin")
	if not plugin:
		return _send_error(client_id, "GodotMCPPlugin not found in Engine metadata", command_id)

	# Get MCP panel
	var mcp_panel = plugin.get_mcp_panel()
	if not mcp_panel:
		return _send_error(client_id, "MCP panel not found", command_id)

	# Get log text
	var log_text = mcp_panel.get_log_text()

	# Optional parameters
	var max_lines = params.get("max_lines", 100)
	var start_line = params.get("start_line", 0)

	# Process logs
	var log_lines = log_text.split("\n")
	var total_lines = log_lines.size()

	# Adjust start_line if it's negative
	if start_line < 0:
		start_line = max(0, total_lines + start_line)

	# Calculate end line
	var end_line = min(start_line + max_lines, total_lines)

	# Extract the requested lines
	var requested_logs = []
	for i in range(start_line, end_line):
		requested_logs.append(log_lines[i])

	_send_success(client_id, {
		"logs": requested_logs,
		"total_lines": total_lines,
		"start_line": start_line,
		"end_line": end_line
	}, command_id)

func _clear_server_logs(client_id: int, params: Dictionary, command_id: String) -> void:
	# Get editor plugin and interfaces
	var plugin = Engine.get_meta("GodotMCPPlugin")
	if not plugin:
		return _send_error(client_id, "GodotMCPPlugin not found in Engine metadata", command_id)

	# Get MCP panel
	var mcp_panel = plugin.get_mcp_panel()
	if not mcp_panel:
		return _send_error(client_id, "MCP panel not found", command_id)

	# Clear logs
	mcp_panel.clear_logs()

	_send_success(client_id, {
		"message": "Server logs cleared successfully"
	}, command_id)
