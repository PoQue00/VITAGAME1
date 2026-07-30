extends Control


func _ready():
	$level1.grab_focus()
	Music.play_menu()


func _on_level1_pressed():
	get_tree().change_scene("res://Scene/Level 1.tscn")


func _on_level2_pressed():
	get_tree().change_scene("res://Scene/Level 2.tscn")


func _on_back_pressed():
	get_tree().change_scene("res://Scene/main menu.tscn")
