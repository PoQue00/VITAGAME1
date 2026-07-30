extends Control

func _ready():
	$Panel/tutorial.grab_focus()
	Music.play_menu()



func _on_tutorial_pressed():
	get_tree().change_scene("res://Scene/Tutorial.tscn")

func _on_back_pressed():
	get_tree().change_scene("res://Scene/main menu.tscn")

func _on_chap1_pressed():
	get_tree().change_scene("res://Scene/chap1_select.tscn")
