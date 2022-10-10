extends Spatial


onready var _vehicle = preload("res://Prefabs/Vehicles/Vehicle_Taxi.tscn")
# TODO: optimatize vehicle_list to not grow indefinetly
var vehicle_list: Array = []
export var spawn_chance: int = 10
export var speed_max: float = 0.0
export var speed_min: float = 0.0
var speed: float
export var time_between_spawns: float = 3

# TODO: Add function to clear out of bounds cars. When player despawn spawner it is already despawned
func start(_speed: float) -> void:
	speed = _speed
	$Timer.wait_time = time_between_spawns
	spawn_vehicle()

func spawn_vehicle():
	while true:
		var should_spawn = rand_range(0, 100)
		if(should_spawn < spawn_chance):
			var vehicle = _vehicle.instance()
			add_child(vehicle)
			vehicle_list.append(vehicle)
			vehicle.global_transform.origin = self.global_transform.origin
			vehicle.start(speed)
		$Timer.start()
		yield($Timer, "timeout")


#not working
#func _notification(notification):
#	if notification == NOTIFICATION_PREDELETE:
#		for vehicle in vehicle_list:
#			vehicle.queue_free()

