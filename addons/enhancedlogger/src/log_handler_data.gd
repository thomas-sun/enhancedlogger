## LogHandlerData
## The base class for data transfer in LogHandler, with the class name placed in the tag
class_name LogHandlerData
extends RefCounted

var tag: String
var data: Dictionary = {}

func _init(tag="LogHandlerData") -> void:
	self.tag = tag
