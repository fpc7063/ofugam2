extends Spatial

#data_utils_file
const duf := preload("res://scripts/utils/data.gd")
var du := duf.new()

onready var _spawned_entity = preload("res://Prefabs/Spawned/Spawned.tscn")
var entity_list = [
	"res://vox/vehicles/taxi/",
	"res://vox/people/"
]

# TODO: optimatize vehicle_list to not grow indefinetly
var vehicle_list: Array = []
export var spawn_chance: int = 10
export var speed_max: float = 0.0
export var speed_min: float = 0.0
var speed: float
export var time_between_spawns: float = 3

func start(_speed: float, type: int) -> void:
	speed = _speed
	$Timer.wait_time = time_between_spawns
	if(type == du.ROAD or type == du.ROADLINE):
		start_spawning(entity_list[0])
	elif(type == du.SIDEWALK):
		start_spawning(entity_list[1])


func start_spawning(path: String):
	while true:
		var should_spawn = rand_range(0, 100)
		if(should_spawn < spawn_chance):
			var spawned = _spawned_entity.instance()
			add_child(spawned)
			vehicle_list.append(spawned)
			spawned.global_transform.origin = self.global_transform.origin
			spawned.start(speed, path)
		$Timer.start()
		yield($Timer, "timeout")
