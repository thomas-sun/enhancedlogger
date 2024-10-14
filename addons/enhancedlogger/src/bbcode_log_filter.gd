## BBCodeLogFilter
## Filters BBCode color control codes from log messages
##
## This filter removes color formatting from log messages while preserving the text content.
## Example:
##     Input: "[color=red]Error[/color]: File not found"
##     Output: "Error: File not found"
##
## Note: Currently only handles [color] tags. Other BBCode tags will remain unchanged.
class_name BBCodeLogFilter
extends LogHandler

# Filter rules
const rule = "\\[color=[^\\]]*\\](.*?)\\[\\/color\\]"
# Create RegEx object
var regex = RegEx.new()

func _init() -> void:
	regex.compile(rule)
	#	push_error("Failed to compile BBCode filter regex")
	
# Remove BBCode tags
func remove_bbcode(colored_message: String) -> String:
	var result = colored_message
	var matches = regex.search_all(colored_message)
	
	for match in matches:
		# Get the first capture group (text between color tags)
		var original_text = match.get_string()
		var inner_text = match.get_string(1)
		result = result.replace(original_text, inner_text)
	
	return result	

func _handle(level: LogHandler.LogLevel, timestamp: String, _message: Dictionary, _custom_data: LogHandlerData) -> bool:
	_message.data = remove_bbcode(_message.data)
	return true
