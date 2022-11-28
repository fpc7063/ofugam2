extends Node

# random_utils_file
const ruf := preload("res://scripts/utils/randomize.gd")
var random_utils := ruf.new()
# data_utils_file
const duf := preload("res://scripts/utils/data.gd")
var du := duf.new()


# world handling godot internals
var floor_gridMap: GridMap
var obstacles_gridMap: GridMap

# world borders
var new_world_line: int
var old_world_line: int


# spawner handling utils
var spawner_list: Array = []
onready var _spawner = preload("res://Prefabs/Spawner/spawner.tscn")




func start(f_gridMap: GridMap, o_gridMap: GridMap):
	floor_gridMap = f_gridMap
	obstacles_gridMap = o_gridMap
	new_world_line = du.nwl
	old_world_line = du.owl


# TODO: ensure that there is a path from new_world_line -1 to new_world_line
func add_line() -> void:
	var previous = floor_gridMap.get_cell_item(0, 0, new_world_line)
	var i = check_next(previous)
	new_world_line+=1
	for x in range(-2, 2):
		floor_gridMap.set_cell_item(x, 0, new_world_line, i)
	
	if(i in [du.ROAD, du.ROADLINE, du.SIDEWALK]):
		add_spawner(new_world_line, i)
		add_blocker(new_world_line)
	
	if(i == du.DESERT_SAND):
		add_obstacles(new_world_line)
		

func del_line() -> void:
	# Remove floor
	for x in range(-2, 2):
		floor_gridMap.set_cell_item(x, 0, old_world_line, -1)
		#yield(get_tree(), "idle_frame") #this fixes an uknown bug, perhaps lag?(TODO)
	old_world_line += 1
	
	# Remove obstacles
	for x in range(du.min_x, du.max_x  + 1):
		if(obstacles_gridMap.get_cell_item(x, 0, old_world_line) != -1):
			obstacles_gridMap.set_cell_item(x, 0, old_world_line, -1)
	
	# Remove last spawner if it is on the owl line
	if(spawner_list[0][0] == old_world_line):
		remove_spawner(spawner_list[0])





func add_spawner(line: int, type: int) -> void:
	var side = random_utils.rand_array_element([1, -1])
	
	var new_spawner = _spawner.instance()
	add_child(new_spawner)
	spawner_list.append([line, new_spawner])
	new_spawner.translation = Vector3(40 * side, 2.8, (line * 2) + 1)
	new_spawner.start(type, - side)

func remove_spawner(spawner) -> void:
	spawner[1].queue_free()
	spawner_list.pop_front()
	#Only removes child from tree, does not delete it https://godotengine.org/qa/49429/what-is-difference-queue_free-and-remove_child-what-queue
	#remove_child(spawner[1])
	#check if spawneds are removed

# Todo: not working
func purge_spawners() -> void:
	for spawner in spawner_list:
		remove_spawner(spawner)



func add_blocker(line: int) -> void:
	obstacles_gridMap.set_cell_item(du.min_x, 0, line, 5)
	obstacles_gridMap.set_cell_item(du.max_x, 0, line, 5)

func add_obstacles(line: int) -> void:
	obstacles_gridMap.set_cell_item(du.min_x, 0, line, random_utils.rand_array_element([du.DESERT_BUSH_0, du.DESERT_BUSH_1]))
	obstacles_gridMap.set_cell_item(du.max_x, 0, line, random_utils.rand_array_element([du.DESERT_BUSH_0, du.DESERT_BUSH_1]))
	
	for x in range(du.min_x, du.max_x):
		if((randi() % 10) < 3):
			obstacles_gridMap.set_cell_item(x, 0, line, random_utils.rand_array_element([du.DESERT_BUSH_0, du.DESERT_BUSH_1]))


func check_next(previous: int) -> int:
	var i: int
	# TODO: add more chance to attempting to stay in the same type of line
	match previous:
		du.DESERT_SAND:
			i = random_utils.rand_array_element([du.DESERT_SAND, du.ROAD, du.ROADLINE, du.SIDEWALK])
		du.ROAD:
			i = du.DESERT_SAND
		du.ROADLINE:
			i = random_utils.rand_array_element([du.ROAD, du.ROADLINE, du.SIDEWALK])
		du.SIDEWALK:
			i = random_utils.rand_array_element([du.DESERT_SAND])
		du.NOTHING:
			i = du.DESERT_SAND
	
	return i
