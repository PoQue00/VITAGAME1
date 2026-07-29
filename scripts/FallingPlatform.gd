extends Node2D

export var fall_speed = 300
export var delay = 2.0

var activated = false
var falling = false
var start_position

onready var platform = $StaticBody2D
onready var area = $Area2D
onready var timer = $Timer


func _ready():
	add_to_group("falling_platform")

	start_position = platform.position

	timer.wait_time = delay
	timer.one_shot = true

	timer.connect("timeout", self, "_on_Timer_timeout")
	area.connect("body_entered", self, "_on_Area2D_body_entered")


func _physics_process(delta):
	if falling:
		platform.position.y += fall_speed * delta


func _on_Area2D_body_entered(body):
	if body.name == "Player" and !activated:
		activated = true
		timer.start()


func _on_Timer_timeout():
	falling = true


func reset_platform():
	activated = false
	falling = false
	timer.stop()

	platform.position = start_position
