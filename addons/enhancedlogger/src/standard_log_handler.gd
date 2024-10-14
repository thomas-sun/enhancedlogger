## Standard console output
class_name StandardLogHandler
extends LogHandler

# Output format template
var _template := "{timestamp} {level} {message}"

## Set the timestamp template
func set_template(template):
	_template = template

func _handle(level: LogHandler.LogLevel, timestamp: String, _message: Dictionary, _custom_data: LogHandlerData) -> bool:
	var message: String = _message.data
	var log_message = _template.format({
		timestamp = timestamp,
		level = get_level_string(level),
		message = message,
	})
	print(log_message)
	return true
