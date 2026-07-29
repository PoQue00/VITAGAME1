extends Node

var time := 0.0
var running := true


func _process(delta):
	if running:
		time += delta


func reset():
	time = 0
	running = true


func stop():
	running = false
