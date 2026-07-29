extends Area2D

var deaths = 0
var death_file = "user://deaths.txt"


func _ready():
	connect("body_entered", self, "_on_body_entered")
	load_deaths()


func _on_body_entered(body):
	if body.name == "Player":

		# Add death
		deaths += 1
		save_deaths()

		# Reset falling platforms first
		for platform in get_tree().get_nodes_in_group("falling_platform"):
			platform.reset_platform()

		# Then respawn the player
		body.global_position = body.respawn_position


func load_deaths():
	var file = File.new()

	if file.file_exists(death_file):
		file.open(death_file, File.READ)
		deaths = int(file.get_as_text())
		file.close()
	else:
		save_deaths()


func save_deaths():
	var file = File.new()

	file.open(death_file, File.WRITE)
	file.store_string(str(deaths))
	file.close()
