## ANSICodeLogFilter
## Filters out ANSI escape sequences from log messages
##
## This filter removes ANSI control codes from log messages, making them
## suitable for plain text output or systems that don't support ANSI formatting.
## Example:
##     Input: "\x1B[31mError:\x1B[0m File not found"
##     Output: "Error: File not found"
class_name ANSICodeLogFilter
extends LogHandler

# Filtering rule
const rule = "\\\\x1B(?:[@-Z\\\\\\\\-_]|\\\\[[0-?]*[ -/]*[@-~])"
# Create a regular expression object
var regex = RegEx.new()

func _init() -> void:
	regex.compile(rule)
	#	push_error("Failed to compile Ansi filter regex")
	
# Function to remove ANSI control codes
func remove_ansi_codes(text: String) -> String:
	return regex.sub(text, "", true)

func _handle(level: LogHandler.LogLevel, timestamp: String, _message: Dictionary, _custom_data: LogHandlerData) -> bool:
	_message.data = remove_ansi_codes(_message.data)
	return true
