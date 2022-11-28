extends Control


onready var states = get_node("/root/StateStore")


func _ready():
	$VBoxContainer/OptionsButton.grab_focus()


func _on_OptionsButton_pressed():
	pass # Replace with function body.


func _on_QuitButton_pressed():
	get_tree().quit()
