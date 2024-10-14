## BBCodeLogHandler
## Handles formatted log output using BBCode for the Godot editor output window
##
## This handler allows for colorized output of log messages, with customizable
## colors for different log levels and message components. It uses the print_rich
## function to output formatted text to the Godot editor's output window.
##
## Example usage:
## ```gdscript
## var handler = BBCodeLogHandler.new({
##     "debug": BBCodeLogHandler.FG_GREEN,
##     "error": BBCodeLogHandler.FG_RED
## })
## logger.add_handler(handler)
## ```
class_name BBCodeLogHandler
extends LogHandler

const data_tag = "BBCodeLogHandler"

## Color management, defines common colors and background colors
const FG_BLACK = "black"
const FG_RED = "red"
const FG_GREEN = "green"
const FG_YELLOW = "yellow"
const FG_BLUE = "blue"
const FG_MAGENTA = "magenta"
const FG_CYAN = "cyan"
const FG_WHITE = "white"
const FG_ORANGE = "orange"
const FG_GRAY = "gray"
const FG_PINK = "pink"
const FG_PURPLE = "purple"

# There might be a bug in the Godot editor output window where control codes after line breaks may be printed as text
# Output template, allowing developers to customize the output format
var _template := "[color={color_timestamp}]{timestamp} [/color] [color={color_level}]{level} [/color] [color={color_message}]{message}[/color]"

var color_debug = FG_GREEN
var color_info = FG_BLUE
var color_warning = FG_YELLOW
var color_error = FG_RED
var color_known = FG_CYAN

# LogColor color mapping table
static var color_map : Dictionary = {}

# Set template
func set_template(template):
	_template = template

# Quickly create colors
static func make_color(t:LogColor, l:LogColor, m:LogColor) -> LogHandlerData:
	var data = LogHandlerData.new(BBCodeLogHandler.get_handler_data_tag())
	data.data = { 
		timestamp = color_map.get(t, FG_WHITE),
		level = color_map.get(l, FG_WHITE),
		message = color_map.get(m, FG_WHITE)
	}
	return data
	
static func get_handler_data_tag() -> String:
	return data_tag	
	
# External use should always use LogColor definition
static func colorize(text: String, color: LogColor) -> String:
	var color_code = color_map.get(color, FG_WHITE)
	return "[color=%s]%s[/color]" % [color_code, text]

# Add color attributes
func _colorize(text: String, color_code: String) -> String:
	return "[color=%s]%s[/color]" % [color_code, text]
	
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

# Will use default values if no initial colors are provided
func _init(default_color :Dictionary = {}):
	if default_color:
		color_debug = default_color.get("debug", color_debug)
		color_info = default_color.get("info", color_info)
		color_warning = default_color.get("warning", color_warning)
		color_error = default_color.get("error", color_error)
		color_known = default_color.get("known", color_known)
	create_color_map()

func _print_rich(_custom_data: LogHandlerData, timestamp: String, level: String, message: String, default_colorg: String):
	var color_t
	var color_l
	var color_m
		
	# Use custom colors
	if _custom_data and _custom_data.tag == data_tag:
		var data : Dictionary = _custom_data.data
		color_t = data.get("timestamp", default_colorg)
		color_l = data.get("level", default_colorg)
		color_m = data.get("message", default_colorg)
	else:
		color_t = default_colorg
		color_l = default_colorg
		color_m = default_colorg
		
	var	log_message = _template.format({
			color_timestamp = color_t,
			color_level = color_l,
			color_message = color_m,
			timestamp = timestamp,
			level = level,
			message = message
			})
	print_rich(log_message)

func _handle(level: LogHandler.LogLevel, timestamp: String, _message: Dictionary, _custom_data: LogHandlerData) -> bool:
	var message : String = _message.data
	
	match level:
		LogHandler.LogLevel.DEBUG:
			_print_rich(_custom_data, timestamp, "DEBUG", message, color_debug)
			   
		LogHandler.LogLevel.INFO:
			_print_rich(_custom_data, timestamp, "INFO", message, color_info)
			
		LogHandler.LogLevel.WARNING:
			_print_rich(_custom_data, timestamp, "WARNING", message, color_warning)
			
		LogHandler.LogLevel.ERROR:
			_print_rich(_custom_data, timestamp, "ERROR", message, color_error)
		_:
			_print_rich(_custom_data, timestamp, "UNKNOWN", message, color_known)
			
	return true
