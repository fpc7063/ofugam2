extends Node


const duf := preload("res://scripts/utils/data.gd")
var du := duf.new()
var playerIsAlive: bool = true
var gameIsStarted: bool = false
var playerCurrentZ: int = 0
var world_obj
var player_obj


func _ready():
	pass


func set_world_script(wo):
	world_obj = wo


func set_player_obj(po):
	player_obj = po

func reset_game():
	player_obj.reset_player()
	world_obj.reset_game()
	playerIsAlive = true
	gameIsStarted = false
