extends Node2D



var gridHeight
var gridWidth
var gridPadding
var gridStart 
export (int)var tileSize

onready var gridHolder = $gridLayer/gridHolder
onready var pipeHolder = $gridLayer/gridHolder/pipeHolder


func _ready():
	calcGridSize()
	gridHolder.addSources(gridStart, gridWidth, tileSize)
	gridHolder.addPipes(gridStart, gridWidth, gridHeight, tileSize)
	gridHolder.addBottles(gridStart, gridWidth, gridHeight, tileSize)
	
	
func calcGridSize():
	var gridSize = pipeHolder.rect_size
	

	
	gridPadding  = tileSize / 2
	
	var widthFactor = 1
	var totalWidth = gridSize.x 
	
	
	gridWidth    = floor(   totalWidth / (tileSize - 9))
	gridHeight   = floor(  (gridSize.y) / (tileSize / 2))
	
	

	
	var takenWidth = gridWidth * (tileSize - 9)
	
	var remainWidth  = totalWidth - takenWidth
	
	print(" Window Width: ", gridSize.x, " Taken: ", takenWidth, " Remain: ", remainWidth)
	
	var remainHeight = gridSize.y - (gridHeight * tileSize) 
	
	gridStart    = Vector2(tileSize / 2 + remainWidth / 2, tileSize / 2)
	
	
	
	


