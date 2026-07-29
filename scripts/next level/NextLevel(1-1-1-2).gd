extends Area2D

func _ready():
	connect("body_entered", self, "_on_body_entered")
	SpeedrunTimer.reset()

func _on_body_entered(body):
	if body.name == "Player":
		get_tree().change_scene("res://Scene/main menu.tscn")
