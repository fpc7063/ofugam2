#data_utils_file

enum {
	NOTHING = -1,
	GRASS = 0,
	ROAD = 1,
	ROADLINE = 2,
	SIDEWALK = 3,
	DESERT_SAND = 4,
	
	#General obstacles
		NONE = 5,
	
	#Forest obstacles
		TREE_0 = 0,
		TREE_1 = 1,
		TREE_2 = 3,
		TREE_3 = 4,
		LOG = 4,
		BROWN_ROCK = 4,
	
	#Street obstacles
		BEACON_0 = 6,
		BEACON_1 = 9,
		
	#Desert obstacles
		DESERT_BUSH_0 = 7,
		DESERT_BUSH_1 = 8
}

# world limits
export var new_world_line: int = 40
export var nwl: int = new_world_line
export var old_world_line: int = 0
export var owl: int = old_world_line
export var max_x: int = 10
export var min_x: int = -6
export var player_initial_pos: Vector3 = Vector3(7, 3, 13)
export var camera_initial_pos: Vector3 = Vector3(0, 4, 13)

