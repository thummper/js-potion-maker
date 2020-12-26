extends Node2D

func _draw():
	var col = Color('#f2e7bf')
	col.a = 0.3
	draw_circle( Vector2(0, 0), 30, col)
