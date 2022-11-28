extends Spatial


# random_utils_file
const ruf := preload("res://scripts/utils/randomize.gd")
var random_utils := ruf.new()
# data_utils_file
const duf := preload("res://scripts/utils/data.gd")
var du := duf.new()

# position utils
var z_player: int = 0
var z_cam: int = 0

# world handling godot internals
var meshlib: MeshLibrary
var floor_gridMap: GridMap
var obstacles_gridMap: GridMap


# line handler
onready var lh = get_node("/root/LineHandler")


func _ready() -> void:
	meshlib = $floor.mesh_library
	obstacles_gridMap = $obstacles
	floor_gridMap = $floor
	
	# Cleanup Debugging
	floor_gridMap.clear()
	obstacles_gridMap.clear()

	# Drawboard
	lh.start(floor_gridMap, obstacles_gridMap)
	create_world()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		delete_world()
		create_world()

func delete_world() -> void:
	lh.purge_spawners()
	floor_gridMap.clear()
	obstacles_gridMap.clear()
	#TODO: remove spawners

func create_world() -> void:
	# Ranges through initial world borders creating it
	for z in range(du.old_world_line, du.old_world_line + 10):
		# Force start to be only sand
		var i: int = du.DESERT_SAND
		for x in range(-2, 2):
			floor_gridMap.set_cell_item(x, 0, z, i)
		# Block sides
		obstacles_gridMap.set_cell_item(du.max_x, 0, z, rand_range(7,8))
		obstacles_gridMap.set_cell_item(du.min_x, 0, z, rand_range(7,8))
	
	# Block back
	for x in range(du.min_x, du.max_x):
		obstacles_gridMap.set_cell_item(x, 0, 2, rand_range(7,8))
	
	# Adds the rest of the world
	for z in range(du.old_world_line + 10, du.new_world_line + 1):
		var i: int
		if(z <= 5):
			i = du.DESERT_SAND
		else:
			var previous = floor_gridMap.get_cell_item(0, 0, z - 1)
			i = lh.check_next(previous)
		
		if(i in [du.ROAD, du.ROADLINE, du.SIDEWALK]):
			lh.add_spawner(z, i)
			lh.add_blocker(z)
		
		if((z > 4) and (i == du.DESERT_SAND)):
			lh.add_obstacles(z)
		
		for x in range(-2, 2):
			floor_gridMap.set_cell_item(x, 0, z, i)


func player_height(pos_z) -> float:
	var p: Vector3 = Vector3(0, 0, pos_z)
	var m: Vector3 = floor_gridMap.world_to_map(p)
	var i: int = floor_gridMap.get_cell_item(m.x, m.y, m.z)
	if i == du.DESERT_SAND or i == du.SIDEWALK:
		return 3.0
	else:
		return 2.8
	
