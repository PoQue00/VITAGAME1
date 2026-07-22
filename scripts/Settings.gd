extends Control

var pause_menu
var Player


func _on_Back_pressed():
	pause_menu.get_node("Panel").show()
	pause_menu.get_node("Panel/VBoxContainer/Settings").grab_focus()
	queue_free()


func _on_Fullscreen_pressed():
	OS.window_fullscreen = !OS.window_fullscreen


func _on_DevStats_pressed():
	GameSettings.dev_stats_enabled = !GameSettings.dev_stats_enabled
	print("DevStats:", GameSettings.dev_stats_enabled)
