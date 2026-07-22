extends CanvasLayer

func update_dev_stats():
	visible = GameSettings.dev_stats_enabled

func _process(delta):
	visible = GameSettings.dev_stats_enabled
