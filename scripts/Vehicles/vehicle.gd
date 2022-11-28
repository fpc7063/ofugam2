extends KinematicBody

const random_utils_file := preload("res://scripts/utils/randomize.gd")
var random_utils := random_utils_file.new()
var spawn_list = []
var velocity: Vector3 = Vector3.ZERO


func load_vehicles(path: String) -> void:
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file: String = dir.get_next()
		if(file == ""):
			break
		elif(file.ends_with(".vox")):
			spawn_list.append(file)
	dir.list_dir_end()


func start(speed: float, path: String) -> void:
	load_vehicles(path)
	velocity = Vector3(speed, 0, 0)
	$MeshInstance.rotation_degrees.y = 0.0 if(sign(speed) == 1) else 180.0
	$MeshInstance.mesh = load(path + spawn_list[random_utils.rand_array_index(spawn_list)])
	var c: BoxShape = BoxShape.new()
	c.extents = $MeshInstance.get_aabb().size / 2
	$CollisionShape.shape = c

func get_mesh_size():
	return $MeshInstance.get_aabb().size / 2

func _physics_process(delta: float) -> void:
	velocity = move_and_slide(velocity, Vector3.UP)
