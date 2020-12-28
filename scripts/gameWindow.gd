extends Node2D



var gridHeight
var gridWidth
var gridPadding
var gridStart 
export (int)var tileSize
export var weirdPadding = 9

onready var gridHolder = $gridLayer/gridHolder
onready var pipeHolder = $gridLayer/gridHolder/pipeHolder


func _ready():
	registerButtons()
	calcGridSize()
	gridHolder.addSources(gridStart, gridWidth, tileSize, weirdPadding)
	gridHolder.addPipes(gridStart, gridWidth, gridHeight, tileSize, weirdPadding)
	gridHolder.addBottles(gridStart, gridWidth, gridHeight, tileSize, weirdPadding)
	
	
func registerButtons():
	var buttons = get_tree().get_nodes_in_group("GameButtons")
	for button in buttons:
		var name = button.name
		if name == "fillButton":
			button.connect("pressed", self, "fillButtonPressed")
	
	
func fillButtonPressed():
	print("Fill button pressed")	
	
func calcGridSize():
	var gridSize = pipeHolder.rect_size
	

	
	gridPadding  = tileSize / 2
	
	var widthFactor = 1
	var totalWidth = gridSize.x 
	
	
	gridWidth    = floor(   totalWidth / (tileSize - weirdPadding))
	gridHeight   = floor(  (gridSize.y) / (tileSize / 2))
	
	
	var takenWidth = gridWidth * (tileSize - weirdPadding)
	var remainWidth  = totalWidth - takenWidth
	
	print(" Window Width: ", gridSize.x, " Taken: ", takenWidth, " Remain: ", remainWidth)
	
	var remainHeight = gridSize.y - (gridHeight * tileSize) 
	
	gridStart    = Vector2(tileSize / 2 + remainWidth / 2, tileSize / 2)
	
	
	
	


