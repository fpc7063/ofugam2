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
var z_cam: int = 0

var spawner_list: Array = []
onready var _spawner = preload("res://Prefabs/Spawner/spawner.tscn")


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
	
	if(i in [ROAD, ROADLINE]):
		add_spawner(new_line)
		

func del_line() -> void:
	for x in range(-10, 10):
		$GridMap.set_cell_item(x, 0, old_line, -1)
		#yield(get_tree(), "idle_frame") #this fixes an uknown bug, perhaps lag?(TODO)
	old_line += 1
	
	if(spawner_list[0][0] == old_line):
		remove_spawner()


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
		
		if(i in [ROAD, ROADLINE]):
			add_spawner(z)
		
		for x in range(-10, 10):
			$GridMap.set_cell_item(x, 0, z, i)


func add_spawner(line: int) -> void:
	var spawner = _spawner.instance()
	add_child(spawner)
	spawner_list.append([line, spawner])
	spawner.translation = Vector3(rand_array([40, -40]), 4, (line * 2) + 1)


func remove_spawner() -> void:
	var spawner = spawner_list[0]
	spawner_list.pop_front()
	remove_child(spawner[1])


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
