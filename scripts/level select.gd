extends Control

func _ready():
	$Panel/VBoxContainer/level1.grab_focus()



func _on_1_pressed():
	get_tree().change_scene("res://Scene/level_test.tscn")


func _on_2_pressed():
	get_tree().change_scene("res://Scene/level_test2.tscn")


func _on_back_pressed():
	get_tree().change_scene("res://Scene/main menu.tscn")


func _on_Button_pressed():
	get_tree().change_scene("res://Scene/test3.tscn")


func _on_playground_pressed():
	get_tree().change_scene("res://Scene/test4.tscn")
