@tool
extends EditorPlugin

const AUTOLOADS = {
	ELog = "res://addons/enhancedlogger/src/logger.gd",
}

func _enter_tree() -> void:
	for singleton in AUTOLOADS:
		add_autoload_singleton(singleton, AUTOLOADS[singleton])


func _exit_tree() -> void:
	for singleton in AUTOLOADS:
		remove_autoload_singleton(singleton)
