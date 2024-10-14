## LogHandler
## Base class for other log handlers to inherit, providing a unified interface
## Avoid using log within LogHandler to prevent infinite loops
## All Handlers will run in threads, so operations related to the scene tree are strictly prohibited
class_name LogHandler
extends RefCounted 

# Define standard colors
enum LogColor {
	FG_BLACK = 0,
	FG_RED,
	FG_GREEN,
	FG_YELLOW,
	FG_BLUE,
	FG_MAGENTA,
	FG_CYAN,
	FG_WHITE,
	FG_ORANGE,
	FG_GRAY,
	FG_PINK,
	FG_PURPLE,

	BG_BLACK,
	BG_RED,
	BG_GREEN,
	BG_YELLOW,
	BG_BLUE,
	BG_MAGENTA,
	BG_CYAN,
	BG_WHITE,
	BG_ORANGE,
	BG_GRAY,
	BG_PINK,
	BG_PURPLE
}

enum LogLevel {
	DEBUG = 0,
	INFO,
	WARNING,
	ERROR
}
	
# Method to handle log messages, to be implemented in subclasses
# Messages are encapsulated in a dictionary to allow direct content modification
## The message is wrapped in the 'data' variable
## Returns whether to continue passing down the message
func _handle(_level: LogLevel, _timestamp: String, _message: Dictionary, _custom_data: LogHandlerData) -> bool:
	return true
	
func _shutdown():
	pass

func get_level_string(level: LogLevel) -> String:
	match level:
		LogHandler.LogLevel.DEBUG:
			return "DEBUG"
		LogHandler.LogLevel.INFO:
			return "INFO"
		LogHandler.LogLevel.WARNING:
			return "WARNING"
		LogHandler.LogLevel.ERROR:
			return "ERROR"
		_:
			return "UNKNOWN"
