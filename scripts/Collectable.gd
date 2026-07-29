extends Area2D

export(String) var strawberry_id = "strawberry_1"

var collected = false

onready var sprite = $Sprite


func _ready():
	connect("body_entered", self, "_on_body_entered")

	# Check if this strawberry was already collected
	if strawberry_id in Game.collected_strawberries:
		hide()
		$CollisionShape2D.disabled = true


func _on_body_entered(body):
	if body.name == "Player" and !collected:
		collect()


func collect():
	collected = true

	Game.collected_strawberries.append(strawberry_id)

	$CollisionShape2D.disabled = true

	hide()
