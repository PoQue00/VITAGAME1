extends Control

var pause_menu
var Player

func _on_Back_pressed():
	pause_menu.get_node("Panel").show()
	pause_menu.get_node("Panel/Settings").grab_focus()
	queue_free()


func _on_Fullscreen_pressed():
	OS.window_fullscreen = !OS.window_fullscreen

func _on_Volume_value_changed(value):
	var bus = AudioServer.get_bus_index("Master")
	
	if value <= 0:
		AudioServer.set_bus_volume_db(bus, -80)
	else:
		AudioServer.set_bus_volume_db(bus, linear2db(value / 10.0))
