extends Node

var playtime_seconds = 0.0
var save_timer = 0.0

const SAVE_INTERVAL = 10.0
const SAVE_PATH = "user://playtime.txt"


func _ready():
	load_playtime()


func _process(delta):
	playtime_seconds += delta
	save_timer += delta

	if save_timer >= SAVE_INTERVAL:
		save_timer = 0
		save_playtime()


func save_playtime():
	var file = File.new()

	if file.open(SAVE_PATH, File.WRITE) == OK:
		file.store_string(str(int(playtime_seconds)))
		file.close()


func load_playtime():
	var file = File.new()

	if file.file_exists(SAVE_PATH):
		if file.open(SAVE_PATH, File.READ) == OK:
			playtime_seconds = float(file.get_as_text())
			file.close()
