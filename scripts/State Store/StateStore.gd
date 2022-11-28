extends Node


const duf := preload("res://scripts/utils/data.gd")
var du := duf.new()
var playerIsAlive: bool = true
var gameIsStarted: bool = false
var playerCurrentZ: int = 0
var world_obj
var player_obj
var highest_z: int = 0


func _ready():
	pass


func set_world_script(wo):
	world_obj = wo


func set_player_obj(po):
	player_obj = po


func getWalkCount():
	if(player_obj.translation.z > highest_z):
		highest_z = player_obj.translation.z
		return highest_z


func reset_game():
	player_obj.reset_player()
	world_obj.reset_game()
	playerIsAlive = true
	gameIsStarted = false
