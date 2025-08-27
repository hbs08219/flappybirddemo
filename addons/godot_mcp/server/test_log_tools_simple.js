// 简单的日志工具测试脚本
console.log('=== 测试日志工具可用性 ===\n');

// 检查日志工具是否被正确导入
try {
  // 尝试动态导入日志工具
  const logToolsPath = './dist/tools/log_tools.js';
  console.log('尝试导入日志工具:', logToolsPath);
  
  // 检查文件是否存在
  const fs = require('fs');
  const path = require('path');
  
  const fullPath = path.join(__dirname, 'dist/tools/log_tools.js');
  if (fs.existsSync(fullPath)) {
    console.log('✅ 日志工具文件存在:', fullPath);
    
    // 读取文件内容的前几行来验证
    const content = fs.readFileSync(fullPath, 'utf8');
    const lines = content.split('\n').slice(0, 10);
    console.log('文件前10行:');
    lines.forEach((line, index) => {
      console.log(`${index + 1}: ${line}`);
    });
    
    // 检查是否包含关键内容
    if (content.includes('get_server_logs')) {
      console.log('✅ 文件包含 get_server_logs 工具');
    } else {
      console.log('❌ 文件不包含 get_server_logs 工具');
    }
    
    if (content.includes('logTools')) {
      console.log('✅ 文件包含 logTools 导出');
    } else {
      console.log('❌ 文件不包含 logTools 导出');
    }
    
  } else {
    console.log('❌ 日志工具文件不存在:', fullPath);
  }
  
} catch (error) {
  console.error('测试过程中发生错误:', error);
}

console.log('\n=== 检查MCP服务器配置 ===');

// 检查主入口文件
try {
  const indexPath = path.join(__dirname, 'dist/index.js');
  if (fs.existsSync(indexPath)) {
    console.log('✅ MCP服务器主文件存在');
    
    const indexContent = fs.readFileSync(indexPath, 'utf8');
    
    if (indexContent.includes('logTools')) {
      console.log('✅ 主文件包含 logTools 导入');
    } else {
      console.log('❌ 主文件不包含 logTools 导入');
    }
    
    if (indexContent.includes('log_tools.js')) {
      console.log('✅ 主文件包含 log_tools.js 导入');
    } else {
      console.log('❌ 主文件不包含 log_tools.js 导入');
    }
    
  } else {
    console.log('❌ MCP服务器主文件不存在');
  }
} catch (error) {
  console.error('检查MCP服务器配置时发生错误:', error);
}

console.log('\n=== 测试完成 ===');
console.log('\n建议的解决方案:');
console.log('1. 重新启动MCP服务器');
console.log('2. 重新启动Godot编辑器');
console.log('3. 重新配置MCP客户端');
console.log('4. 检查MCP客户端的工具发现机制');
