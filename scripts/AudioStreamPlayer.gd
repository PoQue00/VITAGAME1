extends AudioStreamPlayer

var menu_music = preload("res://assets/MainMenu.ogg")
var chap1_music = preload("res://assets/chap1.ogg")

func mainmenu():
	if stream != menu_music:
		stream = menu_music
		play()

func chap1():
	if stream != chap1_music:
		stream = chap1_music
		play()
