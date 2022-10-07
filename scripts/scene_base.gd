extends Spatial

func _ready() -> void:
	redraw_board()

func redraw_board() -> void:
	var meshlib = $GridMap.mesh_library
	var grass: int = meshlib.find_item_by_name("grass-0")
	$GridMap.clear()
	for z in range(-5, 60):
		var i: int
		if(z <= 5):
			i = 0
		else:
			i = 1
		for x in range(-10, 10):
			$GridMap.set_cell_item(x, 0, z, i)


func rand_array(list: Array) -> int:
	randomize()
	return list[randi()%list.size()]
