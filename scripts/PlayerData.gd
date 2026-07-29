extends Node

var username = "Player"

const USERNAME_FILE = "user://username.txt"


func _ready():
	load_username()


func load_username():

	var file = File.new()

	if file.file_exists(USERNAME_FILE):

		file.open(USERNAME_FILE, File.READ)

		username = file.get_as_text()

		file.close()

	else:

		save_username()



func save_username():

	var file = File.new()

	file.open(USERNAME_FILE, File.WRITE)

	file.store_string(username)

	file.close()



func set_username(new_name):

	username = new_name

	save_username()
