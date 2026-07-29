extends Node2D

export var bounce_force = -675

onready var sprite = $AnimatedSprite

func _ready():
	connect("body_entered", self, "_on_body_entered")
	sprite.play("idle")

		
func _on_AnimatedSprite_animation_finished():
	if sprite.animation == "jump":
		sprite.play("idle")


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		# Launch the player upward
		body.velocity.y = bounce_force

		# Play bounce animation
		sprite.play("jump")
