extends "res://scripts/tile.gd"


var colourIndex
var sourceColour = Color(1, 1, 1, 1)

func pickSource():
	colourIndex = possibleSourceColours[ randi() % possibleSourceColours.size()]
	sourceColour = colourInformation[ colourIndex ]
	$Sprite.modulate = sourceColour
	
