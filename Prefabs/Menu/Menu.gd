extends Control


var specialProgress: TextureProgress
var walkCount: Label
var _walkCount: int = 0
var _specialProgress: float = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	specialProgress = $SpecialProgress/SpecialTextureProgress
	walkCount = $WalkCount/WalkCountLabel
	specialProgress.value = _specialProgress
	walkCount.text = String(_walkCount)

func walk():
	_walkCount += 1
	_specialProgress += 1.0 / 4.0
	walkCount.text = String(_walkCount)
	specialProgress.value = floor(_specialProgress)
