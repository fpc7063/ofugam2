extends KinematicBody


export var speed: float = 1.0
var vel: Vector3 = Vector3.ZERO

var new_line: int = 0
var old_line: int = 0


func _ready() -> void:
	new_line = translation.x
	old_line = translation.z


func _physics_process(delta) -> void:
	var ratio: int = 0
	var player_z = get_parent().z_player
	var diff = player_z - int(self.translation.z)
	
	# TODO add minimum camera velocity
	if(diff > 20):
		ratio = diff / 5
	print(diff)
	
	new_line = translation.z
	vel = lerp(vel, (speed + ratio) * Vector3.BACK, 0.05)
	vel = move_and_slide(vel)
	if(new_line == old_line + 2):
		old_line = new_line
		var parent = get_parent()
		parent.add_line()
		parent.del_line()
