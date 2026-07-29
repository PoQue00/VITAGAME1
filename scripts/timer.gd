extends CanvasLayer

onready var label = $TimerLabel


func _process(delta):
	var time = SpeedrunTimer.time

	var minutes = int(time / 60)
	var seconds = int(time) % 60
	var milliseconds = int((time - int(time)) * 100)

	label.text = "%02d:%02d:%02d" % [minutes, seconds, milliseconds]
