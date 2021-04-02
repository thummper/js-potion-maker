extends Node2D


var gridRows
var gridCols 
var gridColsAlt






# OLD
var gridPadding
var gridStart 
export (int)var tileSize
export var weirdPadding = 9

onready var gridHolder = $gridLayer/gridHolder
onready var pipeHolder = $gridLayer/gridHolder/pipeHolder


func _ready():
	# This runs at game start.

	# 1 - Register Buttons
	registerButtons();

	# 2 - Make Game Grid. (Assign to global vars)
	[gridRows, gridCols, gridColsAlt] = calculateGridSize()



	calculateGridSize();


	pass
	# registerButtons()
	# calcGridSize()
	# gridHolder.addSources(gridStart, gridWidth, tileSize, weirdPadding)
	# gridHolder.addPipes(gridStart, gridWidth, gridHeight, tileSize, weirdPadding)
	# gridHolder.addBottles(gridStart, gridWidth, gridHeight, tileSize, weirdPadding)
	
	
func registerButtons():
	var buttons = get_tree().get_nodes_in_group("GameButtons")
	for button in buttons:
		var name = button.name
		if name == "fillButton":
			button.connect("pressed", self, "fillButtonPressed")
	
	
func fillButtonPressed():
	print("Fill button pressed")	
	$gridLayer/gridHolder.fillBottles()



func calculateGridSize():
	# Define a row as a full width row and an offset row.
	# The height of a row is tilesize + tilesize/2
	# A minimal gam would need 2 of these minRows

	# Grid starts and ends with full width rows.
	# These rows are reserved for potion sources / bottles
	# All other rows are for pipes

	var minRows   = 2
	var rowHeight = tileSize * 1.5
	

	var screenSize   = gridHolder.rect_size
	var screenWidth  = screenSize.x
	var screenHeight = screenSize.y  
	var numberRows   = floor(screenHeight / rowHeight)

	if numberRows < minRows:
		push_error("GRID GENERATION FAILED")
		# Suicide
		get_tree().quit()


	var actualRows = numberRows * 2 # There are actually this many rows (but when calculating height we have to BORK)
	
	# TODO - PADDING HERE
	
	var numberColumns    = floor(screenWidth / tileSize)
	var numberColumnsAlt = floor((screenHeight - tileSize) / tileSize)

	print("Row Height: ", rowHeight)
	print("Number Rows: ", numberRows)
	print("Number Cols: ", numberColumns)
	print("Number Cols Alt: ", numberColumnsAlt)

	return [actualRows, numberColumns, numberColumnsAlt]














	
	
# func calcGridSize():
# 	var gridSize = pipeHolder.rect_size
# 	gridPadding  = tileSize / 2
	
# 	var widthFactor = 1
# 	var totalWidth = gridSize.x 
	
	
# 	gridWidth    = floor(   totalWidth / (tileSize - weirdPadding))
# 	gridHeight   = floor(  (gridSize.y) / (tileSize / 2))
	
	
# 	var takenWidth = gridWidth * (tileSize - weirdPadding)
# 	var remainWidth  = totalWidth - takenWidth
	
# 	print(" Window Width: ", gridSize.x, " Taken: ", takenWidth, " Remain: ", remainWidth)
	
# 	var remainHeight = gridSize.y - (gridHeight * tileSize) 
	
# 	gridStart    = Vector2(tileSize / 2 + remainWidth / 2, tileSize / 2)
	
	
	
	


