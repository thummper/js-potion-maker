extends "res://scripts/tile.gd"

onready var pipeSprite = $Sprite
signal pipeRotated


var connections     = []
var sources         = []
var bottles         = []
var openConnections = null
var pipeColour      = Color(1, 0, 0)

var pipeIndex       = 0
var orientation     = 0



func setColour():
	$Sprite.modulate = pipeColour
	


func pickPipe():
	pipeIndex = randi() % possiblePipes.size()
	var textureInfo = possiblePipes[pipeIndex]
	var texture = textureInfo[0]
	var hframes = textureInfo[1]
	
	
	
	orientation = randi() % hframes
	
	$Sprite.set_texture(texture)
	$Sprite.hframes = hframes
	$Sprite.frame = orientation
	
	openConnections = pipeConnections[pipeIndex][orientation]

func rotatePipe():
	var numberFrames = $Sprite.hframes
	orientation = (orientation + 1) % numberFrames
	$Sprite.frame = orientation
	openConnections = pipeConnections[pipeIndex][orientation]
	
	print(" ORIENTATION: ", orientation, " HF: ", numberFrames)
	print(" OPEN: ", openConnections)
	emit_signal("pipeRotated")
	


func pickColor():
	pipeColour = Color(1, 1, 1, 1)
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
		pipeColour = colourInformation[summedColours]	
	$Sprite.modulate = pipeColour

	
func resetModulate():
	pipeColour = Color(1, 1, 1, 1)
	$Sprite.modulate = pipeColour
	
func testConnect():
	resetModulate()
	pipeColour = Color(1, 0, 0, 1)
	$Sprite.modulate = pipeColour

func _on_pipe_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		rotatePipe()


func _on_tile_mouse_entered():
	$CanvasLayer.visible = true


func _on_tile_mouse_exited():
	$CanvasLayer.visible = false
