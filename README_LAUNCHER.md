# Flappy Bird 项目启动器使用说明

## 概述

本项目提供了多个快速启动脚本，用于方便地打开Flappy Bird项目。这些脚本会自动检测Godot引擎的位置，并提供多种启动选项。

## 可用的启动脚本

### 中文版本
- `run_flappybird.bat` - Windows批处理文件（推荐）
- `run_flappybird.ps1` - PowerShell脚本

### 英文版本
- `run_flappybird_en.bat` - Windows批处理文件（英文界面）
- `run_flappybird_en.ps1` - PowerShell脚本（英文界面）

## 使用方法

### 方法1：双击运行（推荐）
1. 在Windows资源管理器中找到flappybirddemo目录
2. 双击 `run_flappybird.bat` 文件
3. 按照提示选择启动方式

### 方法2：命令行运行
1. 打开命令提示符或PowerShell
2. 切换到flappybirddemo目录
3. 运行相应的脚本：
   ```cmd
   # 批处理版本
   run_flappybird.bat
   
   # PowerShell版本
   .\run_flappybird.ps1
   ```

## 启动选项

脚本提供以下启动选项：

1. **直接打开项目（推荐）** - 使用 `--path` 参数打开项目
2. **打开编辑器** - 仅启动Godot编辑器
3. **打开项目并运行** - 打开项目并直接运行主场景
4. **退出** - 关闭启动器

## Godot引擎检测

启动脚本会自动检测Godot引擎的位置，按以下优先级：

1. **当前目录的bin文件夹** - 如果项目包含Godot构建
2. **上级目录的godot_source/bin** - 如果存在源码构建
3. **系统PATH** - 如果Godot已安装到系统路径

## 故障排除

### 问题1：找不到Godot引擎
**解决方案：**
- 确保已构建Godot引擎（在godot_source目录运行build.bat）
- 或者将Godot安装到系统PATH中
- 或者手动指定Godot可执行文件路径

### 问题2：项目无法打开
**解决方案：**
- 检查项目文件project.godot是否存在
- 确认在正确的项目目录中运行脚本
- 检查Godot路径设置

### 问题3：PowerShell执行策略限制
**解决方案：**
- 以管理员身份运行PowerShell
- 执行命令：`Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`

## 命令行参数说明

启动脚本使用以下Godot命令行参数：

- `--path <项目路径>` - 指定要打开的项目路径
- `--main-pack <场景文件>` - 指定要运行的主场景文件

## 系统要求

- Windows 10/11
- Godot Engine 4.x
- 支持批处理文件或PowerShell

## 注意事项

- 首次启动可能需要较长时间
- 确保有足够的磁盘空间和内存
- 如果使用杀毒软件，可能需要添加例外规则
- 建议使用控制台版本的Godot以获得更好的调试信息

## 自定义配置

如需修改启动参数或添加其他选项，可以编辑相应的脚本文件。主要配置项包括：

- Godot可执行文件路径
- 项目路径
- 启动参数
- 错误处理逻辑

## 技术支持

如果遇到问题，请检查：
1. Godot引擎是否正确构建
2. 项目文件是否完整
3. 系统权限设置
4. 脚本执行环境

---

*这些启动脚本基于godot_source目录中的原始脚本设计，提供了更灵活的项目启动选项。*
