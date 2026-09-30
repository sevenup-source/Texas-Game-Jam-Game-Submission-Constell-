extends Node2D
class_name PlacedStar

var grid_pos := Vector2i.ZERO
var target_global_pos := Vector2.ZERO
var grid_ref: PuzzleGrid

func initialize(coords: Vector2i, grid: PuzzleGrid) -> void:
	grid_pos = coords
	grid_ref = grid
	global_position = grid.grid_to_world(coords)
	target_global_pos = global_position

func _process(delta: float) -> void:
	global_position = lerp(global_position, target_global_pos, 15.0 * delta)

func trigger_effect() -> void:
	pass # Overridden in push_star.gd and pull_star.gd
