extends Control


var specialProgress: TextureProgress
var walkCount: Label
var _walkCount = 0
var _specialProgress: float = 0


onready var states = get_node("/root/StateStore")


# Called when the node enters the scene tree for the first time.
func _ready():
	specialProgress = $SpecialProgress/SpecialTextureProgress
	walkCount = $WalkCount/WalkCountLabel
	specialProgress.value = _specialProgress
	walkCount.text = String(_walkCount)


func _physics_process(_delta):
	var current_z = states.getWalkCount()
	if(current_z != null):
		_walkCount = (current_z / 2) - 6
		_specialProgress += 1.0 / 4.0
		walkCount.text = String(_walkCount)
		specialProgress.value = floor(_specialProgress)

