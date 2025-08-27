# Godot MCP 日志工具使用说明

## 概述

新增的日志工具为Godot MCP服务器提供了强大的日志读取、过滤和分析功能。这些工具允许用户通过MCP客户端访问和管理Godot编辑器中的服务器日志。

## 可用工具

### 1. get_server_logs

获取服务器日志，支持过滤、搜索和分页功能。

**参数：**
- `max_lines` (可选): 返回的最大日志行数，默认100
- `start_line` (可选): 起始行号，支持负数（从末尾倒数）
- `level` (可选): 日志级别过滤，可选值：'info', 'warn', 'error', 'all'，默认'all'
- `search` (可选): 搜索关键词，在日志消息中搜索包含的文本
- `include_timestamp` (可选): 是否包含时间戳信息，默认true

**使用示例：**
```json
{
  "name": "get_server_logs",
  "arguments": {
    "max_lines": 50,
    "level": "error",
    "search": "connection"
  }
}
```

**响应格式：**
```json
{
  "logs": ["日志内容数组"],
  "total_lines": 过滤后的总行数,
  "start_line": 起始行号,
  "end_line": 结束行号,
  "original_total": 原始日志总行数,
  "filtered": 是否应用了过滤
}
```

### 2. clear_server_logs

清除所有服务器日志。

**参数：**
- `confirm` (必需): 确认标志，必须设置为true才能执行清除操作

**使用示例：**
```json
{
  "name": "clear_server_logs",
  "arguments": {
    "confirm": true
  }
}
```

### 3. get_log_stats

获取日志统计信息，包括总数、级别分布和最近活动。

**参数：**
无

**使用示例：**
```json
{
  "name": "get_log_stats",
  "arguments": {}
}
```

**响应格式：**
```
Log Statistics:
Total log entries: 150
Level distribution:
  - Info: 100
  - Warnings: 30
  - Errors: 15
  - Other: 5

Recent activity (last 10 entries):
  1. [时间戳] 日志消息1
  2. [时间戳] 日志消息2
  ...
```

## 日志级别识别

系统会自动识别以下日志级别：

- **Error**: 包含 "error" 或 "[error]" 的日志
- **Warning**: 包含 "warn", "warning" 或 "[warn]" 的日志  
- **Info**: 包含 "info" 或 "[info]" 的日志
- **Other**: 不匹配上述级别的其他日志

## 分页功能

- 使用 `start_line` 和 `max_lines` 参数实现分页
- `start_line` 支持负数，例如 -10 表示从末尾倒数第10行开始
- 系统会自动调整超出范围的起始行号

## 搜索功能

- 搜索不区分大小写
- 支持部分匹配
- 可以与级别过滤组合使用

## 性能考虑

- 大量日志的过滤和搜索操作可能需要一些时间
- 建议合理设置 `max_lines` 参数
- 日志统计功能会分析所有日志，对于大量日志可能较慢

## 错误处理

所有工具都包含完善的错误处理：
- 连接失败时会自动重试
- 参数验证失败会返回清晰的错误信息
- 网络超时会有适当的错误提示

## 集成说明

这些工具已经集成到MCP服务器中，无需额外配置。确保：
1. Godot编辑器已启动MCP插件
2. WebSocket服务器正在运行
3. MCP客户端已连接到服务器

## 故障排除

如果遇到问题：
1. 检查Godot编辑器的MCP面板是否显示连接状态
2. 确认WebSocket端口设置正确
3. 查看Godot控制台是否有错误信息
4. 验证日志命令处理器是否正确加载
