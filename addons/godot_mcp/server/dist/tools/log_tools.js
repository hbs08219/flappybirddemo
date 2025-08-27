var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __generator = (this && this.__generator) || function (thisArg, body) {
    var _ = { label: 0, sent: function() { if (t[0] & 1) throw t[1]; return t[1]; }, trys: [], ops: [] }, f, y, t, g = Object.create((typeof Iterator === "function" ? Iterator : Object).prototype);
    return g.next = verb(0), g["throw"] = verb(1), g["return"] = verb(2), typeof Symbol === "function" && (g[Symbol.iterator] = function() { return this; }), g;
    function verb(n) { return function (v) { return step([n, v]); }; }
    function step(op) {
        if (f) throw new TypeError("Generator is already executing.");
        while (g && (g = 0, op[0] && (_ = 0)), _) try {
            if (f = 1, y && (t = op[0] & 2 ? y["return"] : op[0] ? y["throw"] || ((t = y["return"]) && t.call(y), 0) : y.next) && !(t = t.call(y, op[1])).done) return t;
            if (y = 0, t) op = [op[0] & 2, t.value];
            switch (op[0]) {
                case 0: case 1: t = op; break;
                case 4: _.label++; return { value: op[1], done: false };
                case 5: _.label++; y = op[1]; op = [0]; continue;
                case 7: op = _.ops.pop(); _.trys.pop(); continue;
                default:
                    if (!(t = _.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) { _ = 0; continue; }
                    if (op[0] === 3 && (!t || (op[1] > t[0] && op[1] < t[3]))) { _.label = op[1]; break; }
                    if (op[0] === 6 && _.label < t[1]) { _.label = t[1]; t = op; break; }
                    if (t && _.label < t[2]) { _.label = t[2]; _.ops.push(op); break; }
                    if (t[2]) _.ops.pop();
                    _.trys.pop(); continue;
            }
            op = body.call(thisArg, _);
        } catch (e) { op = [6, e]; y = 0; } finally { f = t = 0; }
        if (op[0] & 5) throw op[1]; return { value: op[0] ? op[1] : void 0, done: true };
    }
};
import { z } from 'zod';
import { getGodotConnection } from '../utils/godot_connection.js';
/**
 * Definition for log tools - operations that read and manage server logs
 */
export var logTools = [
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
        execute: function (_a) { return __awaiter(void 0, [_a], void 0, function (_b) {
            var godot, result, logCount, totalLines, startLine, endLine, response, error_1;
            var _c = _b.max_lines, max_lines = _c === void 0 ? 100 : _c, _d = _b.start_line, start_line = _d === void 0 ? 0 : _d, _e = _b.level, level = _e === void 0 ? 'all' : _e, search = _b.search, _f = _b.include_timestamp, include_timestamp = _f === void 0 ? true : _f;
            return __generator(this, function (_g) {
                switch (_g.label) {
                    case 0:
                        godot = getGodotConnection();
                        _g.label = 1;
                    case 1:
                        _g.trys.push([1, 3, , 4]);
                        return [4 /*yield*/, godot.sendCommand('get_server_logs', {
                                max_lines: max_lines,
                                start_line: start_line,
                                level: level,
                                search: search,
                                include_timestamp: include_timestamp
                            })];
                    case 2:
                        result = _g.sent();
                        if (result.logs && Array.isArray(result.logs)) {
                            logCount = result.logs.length;
                            totalLines = result.total_lines || 0;
                            startLine = result.start_line || 0;
                            endLine = result.end_line || 0;
                            response = "Retrieved ".concat(logCount, " log entries");
                            if (totalLines > 0) {
                                response += " (showing lines ".concat(startLine + 1, "-").concat(endLine, " of ").concat(totalLines, ")");
                            }
                            if (level !== 'all') {
                                response += " filtered by level: ".concat(level);
                            }
                            if (search) {
                                response += " containing: \"".concat(search, "\"");
                            }
                            response += '\n\n';
                            // Format logs for display
                            if (result.logs.length > 0) {
                                response += result.logs.join('\n');
                            }
                            else {
                                response += 'No logs found matching the criteria.';
                            }
                            return [2 /*return*/, response];
                        }
                        else {
                            return [2 /*return*/, 'No logs available or invalid response format.'];
                        }
                        return [3 /*break*/, 4];
                    case 3:
                        error_1 = _g.sent();
                        throw new Error("Failed to retrieve server logs: ".concat(error_1.message));
                    case 4: return [2 /*return*/];
                }
            });
        }); },
    },
    {
        name: 'clear_server_logs',
        description: 'Clear all server logs from the MCP panel',
        parameters: z.object({
            confirm: z.boolean().optional()
                .describe('Confirmation flag to prevent accidental clearing (default: false)'),
        }),
        execute: function (_a) { return __awaiter(void 0, [_a], void 0, function (_b) {
            var godot, result, error_2;
            var _c = _b.confirm, confirm = _c === void 0 ? false : _c;
            return __generator(this, function (_d) {
                switch (_d.label) {
                    case 0:
                        if (!confirm) {
                            return [2 /*return*/, 'Please set confirm=true to clear server logs. This action cannot be undone.'];
                        }
                        godot = getGodotConnection();
                        _d.label = 1;
                    case 1:
                        _d.trys.push([1, 3, , 4]);
                        return [4 /*yield*/, godot.sendCommand('clear_server_logs', {})];
                    case 2:
                        result = _d.sent();
                        if (result.message) {
                            return [2 /*return*/, result.message];
                        }
                        else {
                            return [2 /*return*/, 'Server logs cleared successfully.'];
                        }
                        return [3 /*break*/, 4];
                    case 3:
                        error_2 = _d.sent();
                        throw new Error("Failed to clear server logs: ".concat(error_2.message));
                    case 4: return [2 /*return*/];
                }
            });
        }); },
    },
    {
        name: 'get_log_stats',
        description: 'Get statistics about server logs including total lines, recent activity, and level distribution',
        parameters: z.object({}),
        execute: function () { return __awaiter(void 0, void 0, void 0, function () {
            var godot, result, logs, totalLines, infoCount_1, warnCount_1, errorCount_1, otherCount_1, recentLogs, response_1, error_3;
            return __generator(this, function (_a) {
                switch (_a.label) {
                    case 0:
                        godot = getGodotConnection();
                        _a.label = 1;
                    case 1:
                        _a.trys.push([1, 3, , 4]);
                        return [4 /*yield*/, godot.sendCommand('get_server_logs', {
                                max_lines: 10000, // Get a large number to analyze
                                start_line: 0
                            })];
                    case 2:
                        result = _a.sent();
                        if (!result.logs || !Array.isArray(result.logs)) {
                            return [2 /*return*/, 'Unable to retrieve logs for analysis.'];
                        }
                        logs = result.logs;
                        totalLines = result.total_lines || logs.length;
                        infoCount_1 = 0;
                        warnCount_1 = 0;
                        errorCount_1 = 0;
                        otherCount_1 = 0;
                        logs.forEach(function (log) {
                            var logStr = log.toLowerCase();
                            if (logStr.includes('[error]') || logStr.includes('error:')) {
                                errorCount_1++;
                            }
                            else if (logStr.includes('[warn]') || logStr.includes('warning:')) {
                                warnCount_1++;
                            }
                            else if (logStr.includes('[info]') || logStr.includes('info:')) {
                                infoCount_1++;
                            }
                            else {
                                otherCount_1++;
                            }
                        });
                        recentLogs = logs.slice(-10);
                        response_1 = "Log Statistics:\n";
                        response_1 += "Total log entries: ".concat(totalLines, "\n");
                        response_1 += "Level distribution:\n";
                        response_1 += "  - Info: ".concat(infoCount_1, "\n");
                        response_1 += "  - Warnings: ".concat(warnCount_1, "\n");
                        response_1 += "  - Errors: ".concat(errorCount_1, "\n");
                        response_1 += "  - Other: ".concat(otherCount_1, "\n\n");
                        response_1 += "Recent activity (last 10 entries):\n";
                        recentLogs.forEach(function (log, index) {
                            response_1 += "  ".concat(index + 1, ". ").concat(log, "\n");
                        });
                        return [2 /*return*/, response_1];
                    case 3:
                        error_3 = _a.sent();
                        throw new Error("Failed to get log statistics: ".concat(error_3.message));
                    case 4: return [2 /*return*/];
                }
            });
        }); },
    },
];
//# sourceMappingURL=log_tools.js.map