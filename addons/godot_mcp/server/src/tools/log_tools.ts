import { z } from 'zod';
import { getGodotConnection } from '../utils/godot_connection.js';
import { MCPTool, CommandResult } from '../utils/types.js';

/**
 * Type definitions for log tool parameters
 */
interface GetLogsParams {
  max_lines?: number;
  start_line?: number;
  level?: 'info' | 'warn' | 'error' | 'all';
  search?: string;
  include_timestamp?: boolean;
}

interface ClearLogsParams {
  confirm?: boolean;
}

/**
 * Definition for log tools - operations that read and manage server logs
 */
export const logTools: MCPTool[] = [
  {
    name: 'get_server_logs',
    description: 'Retrieve server logs from the Godot MCP panel with optional filtering and pagination',
    parameters: z.object({
      max_lines: z.number().optional()
        .describe('Maximum number of log lines to return (default: 100)'),
      start_line: z.number().optional()
        .describe('Starting line number for pagination (can be negative for reverse counting)'),
      level: z.enum(['info', 'warn', 'error', 'all']).optional()
        .describe('Filter logs by level (default: all)'),
      search: z.string().optional()
        .describe('Search keyword to filter log messages'),
      include_timestamp: z.boolean().optional()
        .describe('Whether to include timestamp information (default: true)'),
    }),
    execute: async ({ 
      max_lines = 100, 
      start_line = 0, 
      level = 'all',
      search,
      include_timestamp = true 
    }: GetLogsParams): Promise<string> => {
      const godot = getGodotConnection();
      
      try {
        const result = await godot.sendCommand<CommandResult>('get_server_logs', {
          max_lines,
          start_line,
          level,
          search,
          include_timestamp
        });
        
        if (result.logs && Array.isArray(result.logs)) {
          const logCount = result.logs.length;
          const totalLines = result.total_lines || 0;
          const startLine = result.start_line || 0;
          const endLine = result.end_line || 0;
          
          let response = `Retrieved ${logCount} log entries`;
          if (totalLines > 0) {
            response += ` (showing lines ${startLine + 1}-${endLine} of ${totalLines})`;
          }
          
          if (level !== 'all') {
            response += ` filtered by level: ${level}`;
          }
          
          if (search) {
            response += ` containing: "${search}"`;
          }
          
          response += '\n\n';
          
          // Format logs for display
          if (result.logs.length > 0) {
            response += result.logs.join('\n');
          } else {
            response += 'No logs found matching the criteria.';
          }
          
          return response;
        } else {
          return 'No logs available or invalid response format.';
        }
      } catch (error) {
        throw new Error(`Failed to retrieve server logs: ${(error as Error).message}`);
      }
    },
  },

  {
    name: 'clear_server_logs',
    description: 'Clear all server logs from the MCP panel',
    parameters: z.object({
      confirm: z.boolean().optional()
        .describe('Confirmation flag to prevent accidental clearing (default: false)'),
    }),
    execute: async ({ confirm = false }: ClearLogsParams): Promise<string> => {
      if (!confirm) {
        return 'Please set confirm=true to clear server logs. This action cannot be undone.';
      }
      
      const godot = getGodotConnection();
      
      try {
        const result = await godot.sendCommand<CommandResult>('clear_server_logs', {});
        
        if (result.message) {
          return result.message;
        } else {
          return 'Server logs cleared successfully.';
        }
      } catch (error) {
        throw new Error(`Failed to clear server logs: ${(error as Error).message}`);
      }
    },
  },

  {
    name: 'get_log_stats',
    description: 'Get statistics about server logs including total lines, recent activity, and level distribution',
    parameters: z.object({}),
    execute: async (): Promise<string> => {
      const godot = getGodotConnection();
      
      try {
        // First get all logs to analyze
        const result = await godot.sendCommand<CommandResult>('get_server_logs', {
          max_lines: 10000, // Get a large number to analyze
          start_line: 0
        });
        
        if (!result.logs || !Array.isArray(result.logs)) {
          return 'Unable to retrieve logs for analysis.';
        }
        
        const logs = result.logs;
        const totalLines = result.total_lines || logs.length;
        
        // Analyze log levels
        let infoCount = 0;
        let warnCount = 0;
        let errorCount = 0;
        let otherCount = 0;
        
        logs.forEach(log => {
          const logStr = log.toLowerCase();
          if (logStr.includes('[error]') || logStr.includes('error:')) {
            errorCount++;
          } else if (logStr.includes('[warn]') || logStr.includes('warning:')) {
            warnCount++;
          } else if (logStr.includes('[info]') || logStr.includes('info:')) {
            infoCount++;
          } else {
            otherCount++;
          }
        });
        
        // Get recent activity (last 10 entries)
        const recentLogs = logs.slice(-10);
        
        let response = `Log Statistics:\n`;
        response += `Total log entries: ${totalLines}\n`;
        response += `Level distribution:\n`;
        response += `  - Info: ${infoCount}\n`;
        response += `  - Warnings: ${warnCount}\n`;
        response += `  - Errors: ${errorCount}\n`;
        response += `  - Other: ${otherCount}\n\n`;
        response += `Recent activity (last 10 entries):\n`;
        
        recentLogs.forEach((log, index) => {
          response += `  ${index + 1}. ${log}\n`;
        });
        
        return response;
      } catch (error) {
        throw new Error(`Failed to get log statistics: ${(error as Error).message}`);
      }
    },
  },
];
