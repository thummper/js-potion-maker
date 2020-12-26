extends "res://scripts/tile.gd"

onready var pipeSprite = $Sprite
signal pipeRotated


var connections   = []
var sources       = []
var bottles       = []
var pipeColour    = Color(1, 0, 0)




func setColour():
	$Sprite.modulate = pipeColour
	


func pickPipe():
	var index = randi() % possiblePipes.size()
	var textureInfo = possiblePipes[index]
	var texture = textureInfo[0]
	var hframes = textureInfo[1]
	$Sprite.set_texture(texture)
	$Sprite.hframes = hframes
	$Sprite.frame = 0

func rotatePipe():
	var numberFrames = $Sprite.hframes
	var newFrame = ($Sprite.frame + 1) % numberFrames
	print("Num: ", newFrame, " Number: ", numberFrames)
	$Sprite.frame = ($Sprite.frame + 1) % numberFrames
	emit_signal("pipeRotated")
	
	

func _on_pipe_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		rotatePipe()


func _on_tile_mouse_entered():
	$CanvasLayer.visible = true


func _on_tile_mouse_exited():
	$CanvasLayer.visible = false
