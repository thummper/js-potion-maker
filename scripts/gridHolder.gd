extends Control

var sourceInfo = []
var pipeInfo   = []
var bottleInfo = []
var source     = preload("res://scenes/source.tscn")
var pipe       = preload("res://scenes/pipe.tscn")

export var weirdPadding  = 9
onready var sourceHolder = $sourceHolder
onready var pipeHolder   = $pipeHolder
onready var bottleHolder = $bottleHolder



func checkConnections():
	# So for each pipe, generate their connections
	print("Check connections called, a pipe has been rotated")
	
	# Because my data stucture sucks, generate a list of indices where pipes exist
	var realPipes = {}
	for i in range(pipeInfo.size()):
		var info = pipeInfo[i]
		var gridIndex = info[0]
		realPipes[gridIndex] = i
		
	
	for info in pipeInfo:
		var gridIndex = info[0]
		var pipe      = info[1]
		# Reset pipe's current connections
		pipe.connections = []
		pipe.sources     = []
		pipe.bottles     = []
		
		
		# Get pipe's current open connections
		var openConnections = pipe.openConnections
		# Get pipe: LU, LD, U, D, RU, RD and check if there is a connection
		
		var left  = Vector2( gridIndex.x - 1, gridIndex.y)
		var right = Vector2( gridIndex.x + 1, gridIndex.y)
		
		var lu    = Vector2( left.x, left.y - 1)
		var ld    = Vector2( left.x, left.y + 1)
		var ru    = Vector2( right.x, right.y - 1)
		var rd    = Vector2( right.x, right.y + 1)
		var above = Vector2( gridIndex.x, gridIndex.y - 1)
		var below = Vector2( gridIndex.x, gridIndex.y + 1)
		
		if realPipes.has(lu):
			print("LU")
		if realPipes.has(ld):
			print("LD")
		if realPipes.has(ru):
			print("RU")
		if realPipes.has(rd):
			print("RD")
		if realPipes.has(above):
			print("ABV")
		if realPipes.has(below):
			print("BLW")
		
		
		
		

func addSources(gridStart, gridWidth, tileSize):
	var startX = gridStart.x
	for i in range(gridWidth):
		# Make a new source
		if i % 2 == 0:
			var sourceInd = Vector2(i, 0)
			var newSource = source.instance()
			newSource.position = Vector2( startX, gridStart.y + tileSize / 2)
			sourceHolder.add_child(newSource)
			sourceInfo.push_back( [sourceInd, newSource])
		startX += tileSize - weirdPadding
		
		
		
func makePipe(x, y, w, h):
	var gridIndex = Vector2(w, h)
	print("Grid index: ", gridIndex)
	var newPipe = pipe.instance()
	newPipe.pickPipe()
	newPipe.position = Vector2(x, y)
	pipeHolder.add_child(newPipe)
	newPipe.connect("pipeRotated", self, "checkConnections")
	pipeInfo.push_back( [ gridIndex, newPipe ])
	
		
func addPipes(gridStart, gridWidth, gridHeight, tileSize):
	var baseStart = gridStart.x
	var altStart  = gridStart.x + tileSize
	var baseHeight = gridStart.y
	var y = baseHeight
	for h in range(gridHeight):
		var altRow = false
		
		if h % 2 != 0:
			altRow = true
			
		var x = baseStart
		for w in range(gridWidth):
			if altRow:
				if w % 2 == 0:
					makePipe(x, y, w, h)
			else:
				if w % 2 != 0:
					makePipe(x, y, w, h)
				
			

			x += (tileSize - weirdPadding)
		y += (tileSize / 2)

	
	
	

	
	
#	for i in range(gridHeight):
#		var width  = gridWidth
#		var x      = baseStart
#		var altRow = false
#		var modVal = 2
#
#
#
#		
#			altRow = true
#			modVal = 3
#			width = shortWidth
#			x     = shortStart
#
#		for j in range(width):
#			# Make pipe
#
#			if j % modVal == 0:
#
#				var newPipe = pipe.instance()
#				var pipeInd = Vector2(i, j)
#				newPipe.position = Vector2(x, startY)
#				pipeHolder.add_child(newPipe)
#				pipeInfo.push_back( [pipeInd, newPipe])
#			x += tileSize
#		startY += tileSize

