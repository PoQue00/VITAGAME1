extends Control

onready var level_list = $Panel/LevelList
onready var global_best = $Panel/GlobalBest
export var thecurrentlevelineedtoshowtheleaderboardfor = ""

func _ready():
	$Panel/Back.grab_focus()
	# Connect to Supabase response
	Supabase.connect(
		"leaderboard_received",
		self,
		"_show_global_leaderboard"
	)

	show_personal_bests()

	# Request online leaderboard
	Supabase.get_leaderboard(thecurrentlevelineedtoshowtheleaderboardfor)

func show_personal_bests():

	for child in level_list.get_children():
		child.queue_free()


	var label = Label.new()


	if TimeSave.best_times.has(thecurrentlevelineedtoshowtheleaderboardfor):

		var time = TimeSave.best_times[thecurrentlevelineedtoshowtheleaderboardfor]

		label.text = (
			"Personal Best "
			+ thecurrentlevelineedtoshowtheleaderboardfor
			+ " : "
			+ format_time(time)
		)

	else:

		label.text = (
			"Personal Best "
			+ thecurrentlevelineedtoshowtheleaderboardfor
			+ " : No Time"
		)


	level_list.add_child(label)

func _show_global_leaderboard(data):

	print("Leaderboard received:")
	print(data)


	# Add a separator
	var title = Label.new()
	title.text = "\nGLOBAL LEADERBOARD"
	level_list.add_child(title)


	# Supabase returns an array of entries
	for entry in data:

		var label = Label.new()

		label.text = (
			str(entry["player_name"])
			+ " - "
			+ format_time(float(entry["time"]))
		)

		level_list.add_child(label)



func format_time(time):

	var minutes = int(time / 60)
	var seconds = int(time) % 60
	var milliseconds = int((time - int(time)) * 100)

	return "%02d:%02d.%02d" % [
		minutes,
		seconds,
		milliseconds
	]


func _on_Back_pressed():

	get_tree().change_scene(
		"res://Scene/Records main.tscn"
	)
