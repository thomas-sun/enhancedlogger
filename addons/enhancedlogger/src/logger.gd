extends Node
## Logging System
## autoload

# Import the enum of LogHandler
enum LogLevel {
	DEBUG = 0,
	INFO,
	WARNING,
	ERROR
}

class Options:
	var Enabled_StandardLogHandler
	var Enabled_ANSICodeLogHandler
	var Enabled_BBCodeLogHandler
	var Enabled_FileLogHandler
	var Enabled_ANSICodeLogFilter
	var Enabled_BBCodeLogFilter

@export var current_level: LogLevel = LogLevel.DEBUG
# Timestamp template
@export var timestamp_template := "{year}:{month}:{day}:{hour}:{minute}:{second}"

var handlers: Array = []

func _init():
	# No specific actions during initialization; the handler will start when added to the scene tree
	pass

func _enter_tree():
	var options = ELog.Options.new()
	options.Enabled_StandardLogHandler = true
	# default output
	ELog.setup(options)

func _exit_tree():
	clear_handlers()

func clear_handlers():
	for handler in handlers:
		handler._shutdown()
	handlers.clear()

func setup(options : Options):
	clear_handlers()
	
	if options.Enabled_StandardLogHandler:
		add_handler(StandardLogHandler.new())
	if options.Enabled_ANSICodeLogHandler:
		add_handler(ANSICodeLogHandler.new())
	if options.Enabled_BBCodeLogHandler:
		add_handler(BBCodeLogHandler.new())
				
	if options.Enabled_ANSICodeLogFilter:
		add_handler(ANSICodeLogFilter.new())
	if options.Enabled_BBCodeLogFilter:
		add_handler(BBCodeLogFilter.new())	
		
	if options.Enabled_FileLogHandler:
		var file_log_handler = FileLogHandler.new()
		file_log_handler.set_enable(true) 
		add_handler(file_log_handler)

## Set the timestamp template
func set_timestamp_template(template):
	timestamp_template = template

func add_handler(handler: LogHandler) -> void:
	handlers.append(handler)

func remove_handler(handler: LogHandler) -> void:
	handlers.erase(handler)

# Logs will not be processed until the thread starts
func _log(level: LogLevel, message: String, custom_data: LogHandlerData) -> void:
	if level < current_level:
		return

	# Apply the timestamp template
	var timestamp = timestamp_template.format(Time.get_datetime_dict_from_system())
	var wrapper = {"data": message}
	for handler in handlers:
		if not handler._handle(level, timestamp, wrapper, custom_data):
			return
	
func debug(message: String, custom_data = null) -> void:
	_log(LogLevel.DEBUG, message, custom_data)

func info(message: String, custom_data = null) -> void:
	_log(LogLevel.INFO, message, custom_data)

func warning(message: String, custom_data = null) -> void:
	_log(LogLevel.WARNING, message, custom_data)

func error(message: String, custom_data = null) -> void:
	_log(LogLevel.ERROR, message, custom_data)
