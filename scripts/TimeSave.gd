extends Node

const SAVE_FILE = "user://times.cfg"

var best_times = {}


func _ready():
	load_times()


func load_times():
	var config = ConfigFile.new()

	if config.load(SAVE_FILE) == OK:
		best_times = config.get_value("Times", "BestTimes", {})
	else:
		best_times = {}


func save_times():
	var config = ConfigFile.new()

	config.set_value("Times", "BestTimes", best_times)
	config.save(SAVE_FILE)


func record_time(level_name, time):
	if !best_times.has(level_name):
		best_times[level_name] = time

	elif time < best_times[level_name]:
		best_times[level_name] = time

	save_times()


func get_best_time(level_name):
	if best_times.has(level_name):
		return best_times[level_name]

	return -1
