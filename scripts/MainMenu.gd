extends Control

func _ready():
	$play.grab_focus()
func _on_play_pressed():
	get_tree().change_scene("res://Scene/Tutorial.tscn")

func _on_select_pressed():
	get_tree().change_scene("res://Scene/levelselect.tscn")

func _on_quit_pressed():
	get_tree().quit()
