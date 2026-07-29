extends Node2D

export(bool) var enabled = true
export(float) var speed_scale = 1.0


func _ready():
	if enabled:
		Engine.time_scale = speed_scale
