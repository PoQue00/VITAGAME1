extends AudioStreamPlayer

var menu_music = preload("res://assets/music/MainMenu.mp3")
var chap1_music = preload("res://assets/music/Chapter1.mp3")

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS

func play_menu():
	if stream != menu_music:
		stream = menu_music
		play()

func play_level1():
	if stream != chap1_music:
		stream = chap1_music
		play()
