extends "res://scripts/tile.gd"


var bottleType   = 0
var bottleColour = 0

func pickBottle():
	var numBottles = $Sprite.hframes
	bottleType     = randi() % numBottles
	$Sprite.frame  = bottleType
	# TODO: Also pick colour here
