extends KinematicBody

const random_utils_file := preload("res://scripts/utils/randomize.gd")
var random_utils := random_utils_file.new()
var taxi_list = []
var velocity: Vector3 = Vector3.ZERO


func load_vehicles() -> void:
	var dir = Directory.new()
	dir.open("res://vox/vehicles/taxi/")
	dir.list_dir_begin()
	while true:
		var file: String = dir.get_next()
		if(file == ""):
			break
		elif(file.ends_with(".vox")):
			taxi_list.append(file)
	dir.list_dir_end()


func start(speed: float) -> void:
	load_vehicles()
	velocity = Vector3(speed, 0, 0)
	$MeshInstance.rotation_degrees.y = 0.0 if(sign(speed) == 1) else 180.0
	$MeshInstance.mesh = load("res://vox/vehicles/taxi/" + taxi_list[random_utils.rand_array_index(taxi_list)])
	var c: BoxShape = BoxShape.new()
	c.extents = $MeshInstance.get_aabb().size / 2
	$CollisionShape.shape = c


func _physics_process(delta: float) -> void:
	velocity = move_and_slide(velocity, Vector3.UP)

