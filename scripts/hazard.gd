extends Area2D

func _ready():
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body):
	if body.name == "Player":
		body.global_position = body.respawn_position
		body.velocity = Vector2.ZERO
