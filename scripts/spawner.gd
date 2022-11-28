extends Spatial

#data_utils_file
const duf := preload("res://scripts/utils/data.gd")
var du := duf.new()

const _spawned_entity = preload("res://Prefabs/Spawned/Spawned.tscn")
var entity_list = [
	"res://vox/vehicles/",
	"res://vox/people/"
]

# TODO: optimatize vehicle_list to not grow indefinetly
var spawned_list: Array = []
export var spawn_chance: int = 10
export var speed_max_cars: float = 10.0
export var speed_min_cars: float = 15.0
export var speed_max_people: float = 5.0
export var speed_min_people: float = 8.0
var speed: float
var direction: int
export var time_between_spawns: float = 3
export var r_time_between_spawns: float = 1.5
var rng: RandomNumberGenerator


func start(type: int, direction: int) -> void:
	rng = RandomNumberGenerator.new()
	$Timer.wait_time = time_between_spawns + rng.randf_range(-r_time_between_spawns, r_time_between_spawns)
	if(type == du.ROAD or type == du.ROADLINE):
		start_spawning(entity_list[0], direction, speed_min_cars, speed_max_cars)
	elif(type == du.SIDEWALK):
		start_spawning(entity_list[1], direction, speed_min_people, speed_max_people)


func start_spawning(pathToTextures: String, spawned_direction: int, min_speed: float, max_speed: float):
	while true:
		var should_spawn = rand_range(0, 100)
		if(should_spawn < spawn_chance):
			var spawned_speed = rand_range(max_speed, min_speed) * spawned_direction
			spawn_child_entity_group(spawned_speed, pathToTextures, spawned_direction)
		$Timer.start()
		yield($Timer, "timeout")

func spawn_child_entity_group(speed: float, pathToTextures: String, spawned_direction: int):
		var offset = Vector3.ZERO
		for counter in range(group_size()):
			var spawned = _spawned_entity.instance()
			add_child(spawned)
			spawned_list.append(spawned)
			spawned.start(speed, pathToTextures)
			spawned.global_transform.origin = self.global_transform.origin + offset
			# adiciona alguma variação ao offset
			var roffset =  rng.randf_range(0, 6) * spawned.get_mesh_size().x
			# por algum motivo não funciona com 1
			offset.x += spawned.get_mesh_size().x * spawned_direction * 3


func group_size():
	# random value
	var rv = rand_range(0, 25)
	# controla a difusão do gráfico
	var cdg = 4
	var result = floor(rv / 5)
	return result if result >= 1 else 1
