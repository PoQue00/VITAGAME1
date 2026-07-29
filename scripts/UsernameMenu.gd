extends Control

onready var username_input = $Panel/UsernameInput


func _ready():
	$Panel/UsernameInput.grab_focus()
	username_input.text = PlayerData.username


func _on_Save_pressed():

	var new_name = username_input.text.strip_edges()


	if new_name == "":
		print("Username cannot be empty")
		return


	if new_name.length() > 16:
		print("Username too long")
		return

	elif new_name.length() < 3:
		print("Username too short")
		return


	PlayerData.set_username(new_name)

	print("Username changed to:", PlayerData.username)


func _on_Back_pressed():

	get_tree().change_scene("res://Scene/main menu.tscn")
