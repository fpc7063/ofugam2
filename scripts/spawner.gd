extends Spatial


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

# TODO: Add function to clear out of bounds cars. When player despawn spawner it is already despawned
func start(_speed: float, type: int) -> void:
	speed = _speed
	$Timer.wait_time = time_between_spawns
	if(type == 1):
		start_spawning(entity_list[0])
	elif(type == 2):
		start_spawning(entity_list[1])


func start_spawning(path: String):
	while true:
		var should_spawn = rand_range(0, 100)
		if(should_spawn < spawn_chance):
			var vehicle = _spawned_entity.instance()
			add_child(vehicle)
			vehicle_list.append(vehicle)
			vehicle.global_transform.origin = self.global_transform.origin
			vehicle.start(speed, path)
		$Timer.start()
		yield($Timer, "timeout")


#not working
#func _notification(notification):
#	if notification == NOTIFICATION_PREDELETE:
#		for vehicle in vehicle_list:
#			vehicle.queue_free()

