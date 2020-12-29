extends "res://scripts/tile.gd"


var bottleType   = 0
var bottleColour = 0
var connections  = []
var sources      = []
var filled       = false
var broken       = false
var colourIndex 
var currentFill  = 0
var maxFill
var bottleFillAmounts = [1, 2, 3, 4]

func resetBottle():
	connections = []
	sources     = []
	filled      = false
	broken      = false
	colourIndex = null
	maxFill     = null
	currentFill = 0


func getInputColor():
	var inputIndex = null
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
		inputIndex = summedColours
	return inputIndex

	

func pickColor():
	bottleColour  = colourInformation[colourIndex]	
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
	maxFill = bottleFillAmounts[bottleType]
	# TODO: Also pick colour here
	colourIndex  = possibleBottleColours[ randi() % possibleBottleColours.size()]
	bottleColour = colourInformation[ colourIndex ]
	$Sprite.modulate = bottleColour
	
	

	
func succFill():
	currentFill += 1
	if currentFill >= maxFill:
		filled = true
		colourIndex = 20
	
	
func failFill():
	broken = true
	$Sprite.texture = brokenSprite
	$Sprite.hframes = 1
	$Sprite.frame = 1
	$Sprite.frame_coords = Vector2(0, 0)
	# If fail we should really swap to broken

func fill():
	# Can only fill if the bottle is not already filled
	if !filled && sources.size() > 0:
		var inputColour = getInputColor()
		
		if inputColour == colourIndex:
			# Input to bottle is equal to bottle colour, so succ fill
			succFill()
		else:
			failFill()
		

	

