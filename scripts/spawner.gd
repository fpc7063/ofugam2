extends Spatial

#data_utils_file
const duf := preload("res://scripts/utils/data.gd")
var du := duf.new()

const _spawned_entity = preload("res://Prefabs/Spawned/Spawned.tscn")
var entity_list = [
	"res://vox/vehicles/taxi/",
	"res://vox/people/"
]

# TODO: optimatize vehicle_list to not grow indefinetly
var vehicle_list: Array = []
export var spawn_chance: int = 10
export var speed_max_cars: float = 10.0
export var speed_min_cars: float = 15.0
export var speed_max_people: float = 5.0
export var speed_min_people: float = 8.0
var speed: float
var direction: int
export var time_between_spawns: float = 3


func start(type: int, direction: int) -> void:
	$Timer.wait_time = time_between_spawns
	if(type == du.ROAD or type == du.ROADLINE):
		start_spawning(entity_list[0], direction, speed_min_cars, speed_max_cars)
	elif(type == du.SIDEWALK):
		start_spawning(entity_list[1], direction, speed_min_people, speed_max_people)


func start_spawning(path: String, spawned_direction: int, min_speed: float, max_speed: float):
	while true:
		var should_spawn = rand_range(0, 100)
		if(should_spawn < spawn_chance):
			var spawned = _spawned_entity.instance()
			add_child(spawned)
			vehicle_list.append(spawned)
			spawned.global_transform.origin = self.global_transform.origin
			var spawned_speed = rand_range(max_speed, min_speed) * spawned_direction
			spawned.start(spawned_speed, path)
		$Timer.start()
		yield($Timer, "timeout")
