## FileLogHandler
## Output to file
class_name FileLogHandler
extends LogHandler

var log_file_path: String = "user://log.txt"
var file
# Whether logging is enabled, controlled by the main thread, so no need for thread safety
var enabled: bool = true
# Output format template
var _template := "{timestamp} {level} {message}"

func _init(path: String = "user://log.txt"):
	log_file_path = path
	_open_file()
	
func _shutdown():
	_close_file()

func _open_file():
	file = FileAccess.open(log_file_path, FileAccess.READ_WRITE)
	# Check if the file was successfully opened
	if file == null:
		# If the file does not exist, create a new file
		file = FileAccess.open(log_file_path, FileAccess.WRITE)
		if file == null:
			push_error("Failed to write to log file: %s" % log_file_path)
	else:
		file.seek_end()

func _close_file():
	if file != null:
		file.close()
		file = null

## Set the timestamp template
func set_template(template):
	_template = template

func set_enable(enable):
	enabled = enable

func _handle(level: LogLevel, timestamp: String, _message: Dictionary, _custom_data: LogHandlerData) -> bool:
	if !enabled || file == null:
		return true
	var message: String = _message.data
	var log_message = _template.format({
		timestamp = timestamp,
		level = get_level_string(level),
		message = message
	})
	file.store_line(log_message)
	return true
