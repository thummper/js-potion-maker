extends "res://scripts/tile.gd"


var bottleType   = 0
var bottleColour = 0
var connections  = []



func resetModulate():
	bottleColour = Color(1, 1, 1, 1)
	$Sprite.modulate = bottleColour
	
func testConnect():
	resetModulate()
	bottleColour = Color(1, 0, 0, 1)
	$Sprite.modulate = bottleColour

func pickBottle():
	var numBottles = $Sprite.hframes
	bottleType     = randi() % numBottles
	$Sprite.frame  = bottleType
	# TODO: Also pick colour here
