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
	
	var widthFactor = 1.25
	var totalWidth = gridSize.x 
	
	
	gridWidth    = floor(   totalWidth / (tileSize / widthFactor))
	gridHeight   = floor(  (gridSize.y) / (tileSize / 2))
	
	
	print(" Total width: ", totalWidth, " Taken Width: ", (gridWidth * (tileSize / widthFactor)))
	
	var remainWidth  = totalWidth - (gridWidth * (tileSize / widthFactor))
	var remainHeight = gridSize.y - (gridHeight * tileSize) 
	
	gridStart    = Vector2(remainWidth / 2, 0)
	print(" Grid Size: ", gridSize, " Width: ", gridWidth, " Height: ", gridHeight)
	
	
	


