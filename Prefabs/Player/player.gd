extends Area

var is_moving: bool = false
var is_rotating: bool = false
var is_breathing: bool = false
var direction: Vector3 = Vector3.ZERO


onready var states = get_node("/root/StateStore")


func _physics_process(delta: float) -> void:
	var r0: float = $MeshInstance.rotation_degrees.y
	var r1: float = $MeshInstance.rotation_degrees.y
	
	
	if(not states.playerIsAlive):
		$Particles.emitting = true
		var squash = Vector3(1.5, 0.2, 1.5)
		$MeshInstance.set_scale(squash)
		return
	
	direction = Vector3.ZERO
	if(Input.is_action_pressed("ui_down")):
		if(r0 != 180.0): r1 = 180.0
		if(not $ray_back.is_colliding()):
			direction = Vector3.FORWARD
	elif(Input.is_action_pressed("ui_up")):
		if(r0 != 0.0): r1 = 0.0
		if(not $ray_front.is_colliding()):
			direction = Vector3.BACK
	elif(Input.is_action_pressed("ui_left")):
		if(r0 != 90): r1 = 90
		if(not $ray_left.is_colliding()):
			direction = Vector3.RIGHT
	elif(Input.is_action_pressed("ui_right")):
		if(r0 != -90): r1 = -90
		if(not $ray_right.is_colliding()):
			direction = Vector3.LEFT


	if(direction == Vector3.BACK):
		get_parent().z_player = int(self.translation.z)
	if((r0 != r1) and (not is_rotating)):
		is_rotating = true
		$tw_rotate.interpolate_property($MeshInstance, "rotation_degrees:y", r0, r1, 0.1, Tween.TRANS_EXPO, Tween.EASE_OUT)
		$tw_rotate.start()
		yield($tw_rotate, "tween_all_completed")
		is_rotating = false

	if((direction != Vector3.ZERO) and (not is_moving)):
		states.gameIsStarted = true
		is_moving = true
		var playerTranslation = self.translation
		# Multiplied by 2 because of cell size in GridMap
		var playerMove = playerTranslation + (direction * 2)
		var playerMoveWithY = Vector3(playerMove.x, get_parent().player_height(playerMove.z), playerMove.z)
		var t = 0.1
		# Order of things are not important in Tween, but there is a function paramenter that tells when to start action
		if(direction == Vector3.BACK): $Interface.walk()
		$tw_jump.interpolate_property(self, "translation", playerTranslation, playerMoveWithY, t, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
		$tw_jump.interpolate_property($MeshInstance, "translation:y", 0.4, 0.0, t/2, Tween.TRANS_LINEAR, Tween.EASE_IN, 0.05)
		$tw_jump.interpolate_property($MeshInstance, "translation:y", 0.0, 0.4, t/2, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$tw_jump.start()
		yield($tw_jump, "tween_all_completed")
		is_moving = false
	
	
	if(not is_breathing):
		is_breathing = true
		var v1 = Vector3.ONE
		var v2 = Vector3(1.1, 0.9, 1.0)
		$tw_breathing.interpolate_property($MeshInstance, "scale", v1, v2, 0.3, Tween.TRANS_SINE, Tween.EASE_IN)
		$tw_breathing.interpolate_property($MeshInstance, "scale", v2, v1, 0.3, Tween.TRANS_SINE, Tween.EASE_IN, 0.3)
		$tw_breathing.start()
		yield($tw_breathing, "tween_all_completed")
		is_breathing = false
		


func _on_player_body_entered(body: Node) -> void:
	states.playerIsAlive = false
