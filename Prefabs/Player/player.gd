extends Area

var is_moving: bool = false
var direction: Vector3 = Vector3.ZERO


func _physics_process(delta: float) -> void:
	direction = Vector3.ZERO
	if(Input.is_action_pressed("ui_up")):
		direction = Vector3.BACK
	elif(Input.is_action_pressed("ui_left")):
		direction = Vector3.RIGHT
	elif(Input.is_action_pressed("ui_right")):
		direction = Vector3.LEFT
	elif(Input.is_action_pressed("ui_down")):
		direction = Vector3.FORWARD

	if(direction == Vector3.BACK):
		get_parent().z_player = int(self.translation.z)

	if((direction != Vector3.ZERO) and (not is_moving)):
		is_moving = true
		var playerTranslation = self.translation
		var playerMove = playerTranslation + (direction * 2)
		$tw.interpolate_property(self, "translation", playerTranslation, playerMove, 0.1, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
		$tw.start()
		yield($tw, "tween_all_completed")
		is_moving = false
