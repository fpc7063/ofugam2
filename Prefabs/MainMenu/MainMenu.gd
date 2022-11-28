extends Control


onready var states = get_node("/root/StateStore")


func _ready():
	$VBoxContainer/OptionsButton.grab_focus()
	if(states.playerIsAlive):
		$VBoxContainer/RestartButton.visible = false


func _physics_process(_delta):
	if(not states.playerIsAlive):
		$VBoxContainer/RestartButton.visible = true


func _on_OptionsButton_pressed():
	pass # Replace with function body.


func _on_QuitButton_pressed():
	get_tree().quit()


func _on_RestartButton_pressed():
	states.reset_game()
