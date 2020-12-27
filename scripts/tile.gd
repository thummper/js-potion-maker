extends Node2D


var possiblePipes = [
	[preload("res://art/CROOKB1.png"), 6],
	[preload("res://art/BEND1.png"), 6],
	[preload("res://art/EB.png"), 6],
	[preload("res://art/CROOKT.png"), 6],
	[preload("res://art/ALLR.png"), 6],
	[preload("res://art/NALL.png"), 6],
	[preload("res://art/CROSSS.png"), 3],
	[preload("res://art/STR.png"), 3],
	[preload("res://art/PEE.png"), 6],
	[preload("res://art/TRI.png"), 2],
	[preload("res://art/ALLA.png"), 1]
]


# Connections in the form:
# [N, NE, SE, S SW, NW]

var pipeConnections = [
	# Open connections for PIPE 0 (CROOK B1) 
	[
		# ORI 0,
		[1, 0, 1, 1, 0, 0],
		# ORI 1,
		[0, 1, 0, 1, 1, 0],
		# ORI 2,
		[0, 0, 1, 0, 1, 1],
		# ORI 3,
		[1, 0, 0, 1, 0, 1],
		# ORI 4,
		[1, 1, 0, 0, 1, 0],
		# ORI 5,
		[0, 1, 1, 0, 0, 1]
	],

	# Open connections for PIPE 1 (BEND 1)
	[
		[1, 0, 0, 0, 1, 0],
		[0, 1, 0, 0, 0, 1],
		[1, 0, 1, 0, 0, 0],
		[0, 1, 0, 1, 0, 0],
		[0, 0, 1, 0, 1, 0],
		[0, 0, 0, 1, 0, 1]
	],
	# Open connections for PIPE 2 (EB)
	[
		[1, 1, 0, 0, 0, 0],
		[0, 1, 1, 0, 0, 0],
		[0, 0, 1, 1, 0, 0],
		[0, 0, 0, 1, 1, 0],
		[0, 0, 0, 0, 1, 1],
		[1, 0, 0, 0, 0, 1]
	],
	# Open connections for PIPE 3 (CROOKT)
	[
		[1, 1, 0, 1, 0, 0],
		[0, 1, 1, 0, 1, 0],
		[0, 0, 1, 1, 0, 1],
		[1, 0, 0, 1, 1, 0],
		[0, 1, 0, 0, 1, 1],
		[1, 0, 1, 0, 0, 1]
	],
	# Open connections for PIPE 4 (ALLR)
	[
		[1, 1, 1, 1, 0, 0],
		[0, 1, 1, 1, 1, 0],
		[0, 0, 1, 1, 1, 1],
		[1, 0, 0, 1, 1, 1],
		[1, 1, 0, 0, 1, 1],
		[1, 1, 1, 0, 0, 1]
	],
	# Open connections for PIPE 5 (NALL)
	[
		[1, 1, 1, 1, 1, 0],
		[0, 1, 1, 1, 1, 1],
		[1 ,0, 1, 1, 1, 1],
		[1, 1, 0, 1, 1, 1],
		[1, 1, 1, 0, 1, 1],
		[1, 1, 1, 1, 0, 1]
	],
	# Open connections for PIPE 6 (CROSS)
	[
		[1, 1, 0, 1, 1, 0],
		[0, 1, 1, 0, 1, 1],
		[1, 0, 1, 1, 0, 1]
	],
	# Open connections for PIPE 7 (STR)
	[
		[1, 0, 0, 1, 0, 0],
		[0, 1, 0, 0, 1, 0],
		[0, 0, 1, 0, 0, 1]
	],
	# Open connections for PIPE 8 (PEE)
	[
		[1, 0, 1, 1, 1, 0],
		[0, 1, 0, 1, 1, 1],
		[1, 0, 1, 0, 1, 1],
		[1, 1, 0, 1, 0, 1],
		[1, 1, 1, 0, 1, 0],
		[0, 1, 1, 1, 0, 1]
	],
	# Open connections for PIPE 9 (TRI)
	[
		[1, 0, 1, 0, 1, 0],
		[0, 1, 0, 1, 0, 1]
	],
	# Open connections for PIPE 10 (ALL)
	[
		[1, 1, 1, 1, 1, 1]
	],
]













