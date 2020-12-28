extends "res://scripts/tile.gd"


var bottleType   = 0
var bottleColour = 0
var connections  = []
var sources      = []
var colourIndex 


func pickColor():
	bottleColour = Color(1, 1, 1, 1)
	if sources.size() > 0:
		# Pipe has associated sources
		var sourceColours = []
		for source in sources:
			sourceColours.push_back( source.colourIndex )
		var nonDupeColours = []
		for colour in sourceColours:
			if nonDupeColours.find(colour) == -1:
				nonDupeColours.push_back(colour)
		var summedColours = 0
		for colour in nonDupeColours:
			summedColours += colour
		colourIndex = summedColours
		bottleColour  = colourInformation[summedColours]	
	$Sprite.modulate = bottleColour

func resetModulate():
	bottleColour = colourInformation[ colourIndex ]
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
	colourIndex = possibleBottleColours[ randi() % possibleBottleColours.size()]
	
	bottleColour = colourInformation[ colourIndex ]
	$Sprite.modulate = bottleColour
	

