extends TileMap

const WIDTH = 10
const HEIGHT = 10
const TILE_ID = 0

func _ready():
	for x in range(WIDTH):
		for y in range(HEIGHT):
			set_cell(x, y, TILE_ID)
