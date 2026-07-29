extends Area2D

export var next_level = ""
export var current_level = ""
export(String) var level_name = ""

func _ready():
	connect("body_entered", self, "_on_body_entered")
	SpeedrunTimer.reset()

func _on_Finish_Line_body_entered(body):
	if body.name == "Player":
		get_tree().change_scene(next_level)
		print("Finish line touched!")

		SpeedrunTimer.stop()

		TimeSave.record_time(level_name, SpeedrunTimer.time)

		Supabase.submit_time(
			level_name,
			SpeedrunTimer.time
)

		print("Finished in:", SpeedrunTimer.time)
		print("PB:", TimeSave.get_best_time(level_name))


func _on_nextlevel_body_entered(body):
	if body.name == "Player":
		get_tree().change_scene(next_level)
		print("Finish line touched!")

		SpeedrunTimer.stop()

		TimeSave.record_time(level_name, SpeedrunTimer.time)

		Supabase.submit_time(
			level_name,
			SpeedrunTimer.time
)

		print("Finished in:", SpeedrunTimer.time)
		print("PB:", TimeSave.get_best_time(level_name))
