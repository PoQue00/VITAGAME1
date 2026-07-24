extends AudioStreamPlayer

var menu_music = preload("res://assets/music/MainMenu.mp3")
var level_music = preload("res://assets/music/Chapter1.mp3")

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS

func play_menu():
	if stream != menu_music:
		stream = menu_music
		play()

func play_level():
	if stream != level_music:
		stream = level_music
		play()
