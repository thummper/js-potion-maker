extends "res://scripts/tile.gd"


var bottleType   = 0
var bottleColour = 0
var connections  = []
var sources      = []
var colourIndex 



func resetModulate():
	bottleColour = colourInformation[ possibleBottleColours[colourIndex] ]
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
	colourIndex = randi() % possibleBottleColours.size()
	
	bottleColour = colourInformation[ possibleBottleColours[colourIndex] ]
	print("Bottle colour: ", bottleColour)
	$Sprite.modulate = bottleColour
	

