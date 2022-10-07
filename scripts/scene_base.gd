extends Spatial

enum {
	NOTHING = -1,
	GRASS = 0,
	ROAD = 1,
	ROADLINE = 2
}

var new_line: int = 40
var old_line: int = -5

var z_player: int = 0


func _ready() -> void:
	redraw_board()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		redraw_board()

func add_line() -> void:
	var previous = $GridMap.get_cell_item(0, 0, new_line)
	var i = check_next(previous)
	new_line+=1
	for x in range(-10, 10):
		$GridMap.set_cell_item(x, 0, new_line, i)
		

func del_line() -> void:
	for x in range(-10, 10):
		$GridMap.set_cell_item(x, 0, old_line, -1)
		#yield(get_tree(), "idle_frame") #this fixes an uknown bug, perhaps lag?(TODO)
	old_line += 1


func redraw_board() -> void:
	var meshlib: MeshLibrary = $GridMap.mesh_library
	var grass: int = meshlib.find_item_by_name("grass-0")
	$GridMap.clear()
	for z in range(old_line, new_line + 1):
		var i: int
		if(z <= 5):
			i = GRASS
		else:
			var previous = $GridMap.get_cell_item(0, 0, z - 1)
			i = check_next(previous)
		
		
		for x in range(-10, 10):
			$GridMap.set_cell_item(x, 0, z, i)

func check_next(previous: int) -> int:
	var i: int
	# TODO: add more change to staying in the same type of biome
	match previous:
		GRASS:
			i = rand_array([GRASS, ROAD, ROADLINE])
		ROAD:
			i = GRASS
		ROADLINE:
			i = rand_array([ROAD, ROADLINE])
		NOTHING:
			i = GRASS
	
	return i

func rand_array(list: Array) -> int:
	randomize()
	return list[randi()%list.size()]
