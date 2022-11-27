extends KinematicBody


export var speed: float = 300.0
var _speed: float
var vel: Vector3 = Vector3.ZERO

var new_line: int = 0
var old_line: int = 0
var cam_stop: bool = false


# line handler
onready var lh = get_node("/root/LineHandler")


func _ready() -> void:
	new_line = translation.x
	old_line = translation.z


func _physics_process(delta) -> void:
	if(cam_stop):
		return
		
	var player_z = get_parent().z_player
	var diff = player_z - int(self.translation.z)
	
	if(diff < -10):
		_speed = 25
	elif(diff < -5):
		_speed = 50
	elif(diff < 1):
		_speed = 150
	elif(diff < 5):
		_speed = 350
	elif(diff < 7):
		_speed = 800
	elif(diff < 10):
		_speed = 1500
	
	new_line = translation.z
	vel = lerp(vel, (_speed * Vector3.BACK) / 100, 0.05)
	vel = move_and_slide(vel)
	
	if(new_line == old_line + 2):
		old_line = new_line
		var parent = get_parent()
		lh.add_line()
		lh.del_line()
