## ANSICodeLogHandler
## Colored terminal output
## Example:
## ```gdscript
## ANSICodeLogHandler.new({
##     debug = ANSICodeLogHandler.FG_GREEN,
##     info = ANSICodeLogHandler.FG_GREEN,
##     warning = ANSICodeLogHandler.FG_GREEN
## })
## ```
class_name ANSICodeLogHandler
extends LogHandler

const data_tag = "ANSICodeLogHandler"

## Color management, defines common colors and background colors
const RESET = "\u001b[0m"
const BOLD = "\u001b[1m"
const UNDERLINE = "\u001b[4m"

const FG_BLACK = "\u001b[30m"
const FG_RED = "\u001b[31m"
const FG_GREEN = "\u001b[32m"
const FG_YELLOW = "\u001b[33m"
const FG_BLUE = "\u001b[34m"
const FG_MAGENTA = "\u001b[35m"
const FG_CYAN = "\u001b[36m"
const FG_WHITE = "\u001b[37m"
const FG_ORANGE = "\u001b[38;5;208m"
const FG_GRAY = "\u001b[90m"
const FG_PINK = "\u001b[38;5;205m"
const FG_PURPLE = "\u001b[35m"

const BG_BLACK = "\u001b[40m"
const BG_RED = "\u001b[41m"
const BG_GREEN = "\u001b[42m"
const BG_YELLOW = "\u001b[43m"
const BG_BLUE = "\u001b[44m"
const BG_MAGENTA = "\u001b[45m"
const BG_CYAN = "\u001b[46m"
const BG_WHITE = "\u001b[47m"
const BG_ORANGE = "\u001b[48;5;208m"
const BG_GRAY = "\u001b[100m"
const BG_PINK = "\u001b[48;5;205m"
const BG_PURPLE = "\u001b[45m"

var color_debug = FG_GREEN
var color_info = FG_BLUE
var color_warning = FG_YELLOW
var color_error = FG_RED
var color_known = FG_CYAN

# Output template, allows developers to customize the output format
var template := "{timestamp} {level} {message}"

# LogColor color mapping table
static var color_map : Dictionary = {}

static func get_handler_data_tag() -> String:
	return data_tag
	
# Quickly create colors
static func make_color(t:LogColor, l:LogColor, m:LogColor) -> LogHandlerData:
	var data = LogHandlerData.new(ANSICodeLogHandler.get_handler_data_tag())
	data.data = { 
		timestamp = color_map.get(t, FG_WHITE),
		level = color_map.get(l, FG_WHITE),
		message = color_map.get(m, FG_WHITE)
	}
	return data
	
# External use should always use LogColor definition
static func colorize(text: String, color: LogColor) -> String:
	var color_code = color_map.get(color, FG_WHITE)
	return color_code + text + RESET

# Add color attributes
func _colorize(text: String, color_code: String) -> String:
	return color_code + text + RESET

# Create color mapping table
func create_color_map():	
	color_map[LogColor.FG_BLACK] = FG_BLACK
	color_map[LogColor.FG_RED] = FG_RED
	color_map[LogColor.FG_GREEN] = FG_GREEN
	color_map[LogColor.FG_YELLOW] = FG_YELLOW
	color_map[LogColor.FG_BLUE] = FG_BLUE
	color_map[LogColor.FG_MAGENTA] = FG_MAGENTA
	color_map[LogColor.FG_CYAN] = FG_CYAN
	color_map[LogColor.FG_WHITE] = FG_WHITE
	color_map[LogColor.FG_ORANGE] = FG_ORANGE
	color_map[LogColor.FG_GRAY] = FG_GRAY
	color_map[LogColor.FG_PINK] = FG_PINK
	color_map[LogColor.FG_PURPLE] = FG_PURPLE

	color_map[LogColor.BG_BLACK] = BG_BLACK
	color_map[LogColor.BG_RED] = BG_RED
	color_map[LogColor.BG_GREEN] = BG_GREEN
	color_map[LogColor.BG_YELLOW] = BG_YELLOW
	color_map[LogColor.BG_BLUE] = BG_BLUE
	color_map[LogColor.BG_MAGENTA] = BG_MAGENTA
	color_map[LogColor.BG_CYAN] = BG_CYAN
	color_map[LogColor.BG_WHITE] = BG_WHITE
	color_map[LogColor.BG_ORANGE] = BG_ORANGE
	color_map[LogColor.BG_GRAY] = BG_GRAY
	color_map[LogColor.BG_PINK] = BG_PINK
	color_map[LogColor.BG_PURPLE] = BG_PURPLE

# Will use default values if no initial colors are provided
func _init(default_color :Dictionary = {}):
	if default_color:
		color_debug = default_color.get("debug", color_debug)
		color_info = default_color.get("info", color_info)
		color_warning = default_color.get("warning", color_warning)
		color_error = default_color.get("error", color_error)
		color_known = default_color.get("known", color_known)
	
	create_color_map()

func _print_color(_custom_data: LogHandlerData, timestamp: String, level: String, message: String, default_colorg: String):
	if _custom_data and _custom_data.tag == data_tag:
		var data : Dictionary = _custom_data.data
		var color_t = data.get("timestamp", default_colorg)
		var color_l = data.get("level", default_colorg)
		var color_m = data.get("message", default_colorg)
		var log_message = template.format({
			timestamp = _colorize(timestamp, color_t),
			level = _colorize(level, color_l),
			message = _colorize(message, color_m),
		})
		print(log_message)
		return
	
	var log_message = template.format({
		timestamp = timestamp,
		level = level, 
		message = message, 
	})
	print(_colorize(log_message, default_colorg))

func _handle(level: LogHandler.LogLevel, timestamp: String, _message: Dictionary, _custom_data: LogHandlerData) -> bool:
	var message : String = _message.data
	
	match level:
		LogHandler.LogLevel.DEBUG:
			_print_color(_custom_data, timestamp, "DEBUG", message, color_debug)
		LogHandler.LogLevel.INFO:
			_print_color(_custom_data, timestamp, "INFO", message, color_info)
		LogHandler.LogLevel.WARNING:
			_print_color(_custom_data, timestamp, "WARNING", message, color_warning)
		LogHandler.LogLevel.ERROR:
			_print_color(_custom_data, timestamp, "ERROR", message, color_error)
		_:
			_print_color(_custom_data, timestamp, "UNKNOWN", message, color_known)
			
	return true
