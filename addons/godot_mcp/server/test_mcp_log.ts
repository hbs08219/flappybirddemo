// 测试通过FastMCP API获取Godot项目日志
import { logTools } from './src/tools/log_tools.js';
import { getGodotConnection } from './src/utils/godot_connection.js';

/**
 * 直接调用log_tools中的函数来测试获取日志功能
 */
async function testLogTools() {
    console.log('=== 测试通过FastMCP API获取Godot日志 ===');

    try {
        // 尝试连接到Godot
        console.log('尝试连接到Godot WebSocket服务器...');
        const godot = getGodotConnection();
        await godot.connect();
        console.log('成功连接到Godot!');

        // 找到get_server_logs工具
        const getLogsTool = logTools.find(tool => tool.name === 'get_server_logs');
        if (!getLogsTool) {
            console.error('未找到get_server_logs工具');
            return;
        }

        // 直接调用工具的execute函数
        console.log('\n=== 测试1: 获取最近的10条日志 ===');
        const logsResult = await getLogsTool.execute({
            max_lines: 10,
            start_line: 0,
            include_timestamp: true
        });
        console.log(logsResult);

        // 测试获取日志统计信息
        const getStatsTool = logTools.find(tool => tool.name === 'get_log_stats');
        if (getStatsTool) {
            console.log('\n=== 测试2: 获取日志统计信息 ===');
            const statsResult = await getStatsTool.execute({});
            console.log(statsResult);
        }

    } catch (error) {
        console.error('测试过程中发生错误:', error);
    } finally {
        // 断开连接
        try {
            const godot = getGodotConnection();
            godot.disconnect();
            console.log('\n已断开与Godot的连接');
        } catch (e) {
            // 忽略断开连接时的错误
        }
    }
}

// 运行测试
console.log('运行测试...');
testLogTools().catch(err => {
    console.error('测试失败:', err);
    process.exit(1);
});