extends Control

func _ready():
	$Menu.grab_focus()

func _on_Tutorial_pressed():
	get_tree().change_scene("res://Scene/Records Tutorial.tscn")

func _on_Level1_pressed():
	get_tree().change_scene("res://Scene/Records Level1.tscn")

func _on_Username_pressed():
	get_tree().change_scene("res://Scene/Username.tscn")

func _on_Menu_pressed():
	get_tree().change_scene("res://Scene/main menu.tscn")

func _on_Level2_pressed():
	get_tree().change_scene("res://Scene/Records Level2.tscn")
