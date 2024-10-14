extends Node2D

var default_bbcode = false

func make_color(timestamp : LogHandler.LogColor, level : LogHandler.LogColor, message : LogHandler.LogColor):
	if default_bbcode:
		return BBCodeLogHandler.make_color(timestamp, level, message)
	else:
		return ANSICodeLogHandler.make_color(timestamp, level, message)

func colorize(text, color : LogHandler.LogColor):
	if default_bbcode:
		return BBCodeLogHandler.colorize(text, color)
	else:
		return ANSICodeLogHandler.colorize(text, color)
		


func _on_StandardLogHandler_pressed() -> void:
	var options = ELog.Options.new()
	options.Enabled_StandardLogHandler = true
	ELog.setup(options)
	ELog.info("StandardLogHandler")

func _on_ANSICodeLogHandler_pressed() -> void:
	var options = ELog.Options.new()
	options.Enabled_ANSICodeLogHandler = true
	ELog.setup(options)
	ELog.info("ANSICodeLogHandler")


func _on_BBCodeLogHandler_pressed() -> void:
	var options = ELog.Options.new()
	options.Enabled_BBCodeLogHandler = true
	ELog.setup(options)
	ELog.info("BBCodeLogHandler")


func _on_test_filter_pressed() -> void:
	var options = ELog.Options.new()
	options.Enabled_BBCodeLogHandler = true
	options.Enabled_BBCodeLogFilter = true
	options.Enabled_FileLogHandler = true
	ELog.setup(options)
	ELog.info("BBCodeLogHandler")
	
func _on_debug_pressed() -> void:
	ELog.debug("debug")
	
func _on_info_pressed() -> void:
	ELog.info("info")

func _on_warning_pressed() -> void:
	ELog.warning("warning")

func _on_error_pressed() -> void:
	ELog.error("error")

func _on_make_color_pressed() -> void:
	ELog.debug("make color", make_color(LogHandler.LogColor.FG_ORANGE, LogHandler.LogColor.FG_PURPLE, LogHandler.LogColor.FG_YELLOW))

func _oncolorize_pressed() -> void:
	ELog.debug(colorize("Hello ",LogHandler.LogColor.FG_ORANGE) + colorize("Godot ",LogHandler.LogColor.FG_RED) + colorize("~~~",LogHandler.LogColor.FG_MAGENTA))


func _on_check_box_toggled(toggled_on: bool) -> void:
	default_bbcode = toggled_on


func _on_custom_pressed() -> void:
	ELog.clear_handlers()

	ELog.add_handler(ANSICodeLogHandler.new())
	ELog.add_handler(BBCodeLogHandler.new())

	ELog.add_handler(ANSICodeLogFilter.new())
	ELog.add_handler(BBCodeLogFilter.new())	
	
	var file_log_handler = FileLogHandler.new()
	file_log_handler.set_enable(true) 
	ELog.add_handler(file_log_handler)
