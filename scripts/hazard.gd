extends Area2D

func _ready():
	connect("body_entered", self, "_on_body_entered")


func _on_body_entered(body):
	if body.name == "Player":

		# Reset falling platforms first
		for platform in get_tree().get_nodes_in_group("falling_platform"):
			platform.reset_platform()

		# Then respawn the player
		body.global_position = body.respawn_position
