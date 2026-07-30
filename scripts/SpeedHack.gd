extends Node2D

export(bool) var enabled = true
export(float) var DONT_MESS = 1.0


func _ready():
	if enabled:
		Engine.time_scale = DONT_MESS
