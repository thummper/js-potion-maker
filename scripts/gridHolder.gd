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
		pipe.resetModulate()

		
		# Get pipe's current open connections
		var openConnections = pipe.openConnections
		# Get pipe: LU, LD, U, D, RU, RD and check if there is a connection
		
		var left  = Vector2( gridIndex.x - 1, gridIndex.y)
		var right = Vector2( gridIndex.x + 1, gridIndex.y)
		
		var lu    = Vector2( left.x, left.y - 1)
		var ld    = Vector2( left.x, left.y + 1)
		var ru    = Vector2( right.x, right.y - 1)
		var rd    = Vector2( right.x, right.y + 1)
		var above = Vector2( gridIndex.x, gridIndex.y - 2)
		var below = Vector2( gridIndex.x, gridIndex.y + 2)
		
		if realPipes.has(lu):
			# There is a pipe LU from this pipe, are they connected?
			# PIPE IN LU CAN CONNECT IF:
			# THIS PIPE HAS LU OPEN (IND 5)
			# TEST PIPE HAS RD OPEN (IND 2)
			var testPipe = pipeInfo[ realPipes[lu] ][1]
			var testConnections = testPipe.openConnections
			
			if openConnections[5] && testConnections[2]:
				pipe.testConnect()
				testPipe.testConnect()
				if ! pipe.connections.has(testPipe):	
					pipe.connections.push_back(testPipe)
				if ! testPipe.connections.has(pipe):
					testPipe.connections.push_back(pipe)
					

		if realPipes.has(ld):
			# There is a pipe LD from this pipe, 
			# Pipe in LD can connect if:
			# This pipe has LD OPEN (IND 4)
			# Test pipe has RU OPEN (IND 1)
			
			var testPipe = pipeInfo[ realPipes[ld] ][1]
			var testConnections = testPipe.openConnections
			
			if openConnections[4] && testConnections[1]:
				pipe.testConnect()
				testPipe.testConnect()
				if ! pipe.connections.has(testPipe):
					pipe.connections.push_back(testPipe)
				if ! testPipe.connections.has(pipe):
					testPipe.connections.push_back(pipe)
			

		if realPipes.has(ru):
			# There is a pipe RU from this pipe
			# Pipe in RU can connect if:
			# This pipe has RU open (IND 1)
			# Test pipe has LD open (IND 4)
			var testPipe = pipeInfo[ realPipes[ru] ][1]
			var testConnections = testPipe.openConnections
			
			if openConnections[1] && testConnections[4]:
				pipe.testConnect()
				testPipe.testConnect()
				if ! pipe.connections.has(testPipe):
					pipe.connections.push_back(testPipe)
				if ! testPipe.connections.has(pipe):
					testPipe.connections.push_back(pipe)
			
		if realPipes.has(rd):
			# There is a pipe RD from this pipe
			# Can connect if:
			# This pipe has RD open (IND 2)
			# Test pipe has RU open (IND 5)
			var testPipe = pipeInfo[ realPipes[rd] ][1]
			var testConnections = testPipe.openConnections
			
			if openConnections[2] && testConnections[5]:
				pipe.testConnect()
				testPipe.testConnect()
				if ! pipe.connections.has(testPipe):
					pipe.connections.push_back(testPipe)
				if ! testPipe.connections.has(pipe):
					testPipe.connections.push_back(pipe)
			
			
		if realPipes.has(above):
			# There is a pipe above this one
			# Connects if:
			# This pipe has above open (IND 0)
			# Above pipe has below open (IND 3)
			var testPipe = pipeInfo[ realPipes[above] ][1]
			var testConnections = testPipe.openConnections
			
			if openConnections[0] && testConnections[3]:
				pipe.testConnect()
				testPipe.testConnect()
				if ! pipe.connections.has(testPipe):
					pipe.connections.push_back(testPipe)
				if ! testPipe.connections.has(pipe):
					testPipe.connections.push_back(pipe)
			
		if realPipes.has(below):
			# There is a pipe below this one
			# Connects if:
			# This pipe has below open (IND 3)
			# Below pipe has above open (IND 0)
			var testPipe = pipeInfo[ realPipes[below] ][1]
			var testConnections = testPipe.openConnections
			if openConnections[3] && testConnections[0]:
				pipe.testConnect()
				testPipe.testConnect()
				if ! pipe.connections.has(testPipe):
					pipe.connections.push_back(testPipe)
				if ! testPipe.connections.has(pipe):
					testPipe.connections.push_back(pipe)
		
		
		
		

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

