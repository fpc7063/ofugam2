extends Spatial


const random_utils_file := preload("res://scripts/utils/randomize.gd")
var random_utils := random_utils_file.new()


enum {
	NOTHING = -1,
	GRASS = 0,
	ROAD = 1,
	ROADLINE = 2
}

var new_line: int = 20
var old_line: int = -5
var z_player: int = 0
var z_cam: int = 0
export var max_x: int = 10
export var min_x: int = -6

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
	for x in range(-2, 2):
		print(x)
		$GridMap.set_cell_item(x, 0, new_line, i)
	
	if(i in [ROAD, ROADLINE]):
		add_spawner(new_line)
		add_blocker(new_line)
	
	if(i == GRASS):
		add_obstacles(new_line)
		

func del_line() -> void:
	for x in range(-1, 1):
		$GridMap.set_cell_item(x, 0, old_line, -1)
		#yield(get_tree(), "idle_frame") #this fixes an uknown bug, perhaps lag?(TODO)
	old_line += 1
	
	for x in range(min_x, max_x  + 1):
		if($obstacles.get_cell_item(x, 0, old_line) != -1):
			$obstacles.set_cell_item(x, 0, old_line, -1)
	
	if(spawner_list[0][0] == old_line):
		remove_spawner()


func redraw_board() -> void:
	var meshlib: MeshLibrary = $GridMap.mesh_library
	var grass: int = meshlib.find_item_by_name("grass-0")
	$GridMap.clear()
	$obstacles.clear()
	#TODO: reset not working
	#if(not spawner_list == []):
	#	for spawner in spawner_list:
	#		spawner[1].queue_free()
	#		spawner_list.pop_front()
	for z in range(old_line, new_line + 1):
		var i: int
		if(z <= 5):
			i = GRASS
		else:
			var previous = $GridMap.get_cell_item(0, 0, z - 1)
			i = check_next(previous)
		
		if(i in [ROAD, ROADLINE]):
			add_spawner(z)
			add_blocker(z)
		
		if((z > 4) and (i == GRASS)):
			add_obstacles(z)
		
		for x in range(-2, 2):
			$GridMap.set_cell_item(x, 0, z, i)


func add_spawner(line: int) -> void:
	var side = random_utils.rand_array_element([1, -1])
	var time = rand_range(2.0, 5.0)
	var speed = rand_range(10.0, 15.0) * (- side)
	
	var spawner = _spawner.instance()
	add_child(spawner)
	spawner_list.append([line, spawner])
	spawner.translation = Vector3(40 * side, 2.8, (line * 2) + 1)
	spawner.start(speed)


func remove_spawner() -> void:
	var spawner = spawner_list[0]
	spawner_list.pop_front()
	spawner[1].queue_free()
	#Only removes child from tree, does not delete it https://godotengine.org/qa/49429/what-is-difference-queue_free-and-remove_child-what-queue
	#remove_child(spawner[1])


func add_blocker(line: int) -> void:
	$obstacles.set_cell_item(min_x, 0, line, 5)
	$obstacles.set_cell_item(max_x, 0, line, 5)

func add_obstacles(line: int) -> void:
	$obstacles.set_cell_item(min_x, 0, line, randi() % 5)
	$obstacles.set_cell_item(max_x, 0, line, randi() % 5)
	
	for x in range(min_x, max_x):
		if((randi() % 10) < 3):
			$obstacles.set_cell_item(x, 0, line, randi() % 5)


func check_next(previous: int) -> int:
	var i: int
	# TODO: add more change to staying in the same type of biome
	match previous:
		GRASS:
			i = random_utils.rand_array_element([GRASS, ROAD, ROADLINE])
		ROAD:
			i = GRASS
		ROADLINE:
			i = random_utils.rand_array_element([ROAD, ROADLINE])
		NOTHING:
			i = GRASS
	
	return i


func player_height(pos_z) -> float:
	var p: Vector3 = Vector3(0, 0, pos_z)
	var m: Vector3 = $GridMap.world_to_map(p)
	var i: int = $GridMap.get_cell_item(m.x, m.y, m.z)
	return 3.0 if i == GRASS else 2.8
	
