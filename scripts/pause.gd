extends CanvasLayer

var settings_scene = preload("res://Scene/Settings.tscn")
var settings_instance


func _ready():
	visible = false
	pause_mode = Node.PAUSE_MODE_PROCESS

	$Panel/VBoxContainer/Resume.connect("pressed", self, "_on_Resume_pressed")
	$Panel/VBoxContainer/Menu.connect("pressed", self, "_on_Menu_pressed")
	$Panel/VBoxContainer/Quit.connect("pressed", self, "_on_Quit_pressed")

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused:
			resume_game()
		else:
			pause_game()

func pause_game():
	visible = true
	get_tree().paused = true

	$Panel/VBoxContainer/Resume.grab_focus()

func resume_game():
	visible = false
	get_tree().paused = false

func _on_Resume_pressed():
	resume_game()

func _on_Menu_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://Scene/main menu.tscn")

func _on_Quit_pressed():
	get_tree().quit()

func _on_Settings_pressed():
	settings_instance = settings_scene.instance()
	settings_instance.pause_menu = self
	add_child(settings_instance)
	$Panel.hide()
	settings_instance.get_node("Panel/Back").grab_focus()
