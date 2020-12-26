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
	
	
func calcGridSize():
	var gridSize = pipeHolder.rect_size
	gridPadding  = tileSize / 2
	gridWidth    = floor(  (gridSize.x - (gridPadding * 2)) / tileSize)
	gridHeight   = floor(  (gridSize.y) / (tileSize / 2))
	gridStart    = Vector2( tileSize / 2 + gridPadding, tileSize / 2 + gridPadding)
	print(" Grid Size: ", gridSize, " Width: ", gridWidth, " Height: ", gridHeight)
	
	
	


