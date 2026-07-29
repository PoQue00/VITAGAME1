extends Control

func _ready():
	$play.grab_focus()
	Music.play_menu()



func _on_play_pressed():
	get_tree().change_scene("res://Scene/Tutorial.tscn")

func _on_select_pressed():
	get_tree().change_scene("res://Scene/levelselect.tscn")

func _on_quit_pressed():
	get_tree().quit()

func _on_leaderboard_pressed():
	get_tree().change_scene("res://Scene/Records main.tscn")

func _on_settings_pressed():
	get_tree().change_scene("res://Scene/Options.tscn")
