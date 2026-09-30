@tool
extends GridContainer
class_name PuzzleGrid

@export var width := 5:
	set(v): width = v; _rebuild()
@export var height := 5:
	set(v): height = v; _rebuild()
@export var cellWidth := 100:
	set(v): cellWidth = v; _rebuild()
@export var cellHeight := 100:
	set(v): cellHeight = v; _rebuild()
@export var borderSize := 0:
	set(v): borderSize = v; _rebuild()

var loose_star_map: Dictionary = {} 

const GRID_CELL = preload("res://Assets/Sprites/grid_cell.tscn")

func _rebuild() -> void:
	_remove_grid()
	_create_grid()

func _create_grid() -> void:
	add_theme_constant_override("h_separation", borderSize)
	add_theme_constant_override("v_separation", borderSize)
	columns = width
	for i in width * height:
		var cell = GRID_CELL.instantiate()
		cell.custom_minimum_size = Vector2(cellWidth, cellHeight)
		add_child(cell)

func _remove_grid() -> void:
	for node in get_children():
		node.queue_free()

func get_cell_node(coords: Vector2i) -> Control:
	if coords.x < 0 or coords.x >= width or coords.y < 0 or coords.y >= height:
		return null
	var index = coords.y * width + coords.x
	if index < get_child_count():
		return get_child(index) as Control
	return null

func world_to_grid(world_pos: Vector2) -> Vector2i:
	var step_x: float = cellWidth + borderSize
	var step_y: float = cellHeight + borderSize
	var local_pos = world_pos - global_position
	return Vector2i(int(floor(local_pos.x / step_x)), int(floor(local_pos.y / step_y)))

func grid_to_world(coords: Vector2i) -> Vector2:
	var tile_size := Vector2(cellWidth + borderSize, cellHeight + borderSize)
	var local_top_left := Vector2(coords.x * tile_size.x, coords.y * tile_size.y)
	
	# Compute half-tile offset using snapped() centering
	var cell_center := local_top_left.snapped(tile_size) + (tile_size / 2.0)
	return global_position + cell_center
	



func register_loose_star(star: loosestar, coords: Vector2i) -> void:
	loose_star_map[coords] = star

func unregister_loose_star(coords: Vector2i) -> void:
	loose_star_map.erase(coords)

func get_loose_star_at(coords: Vector2i) -> loosestar:
	return loose_star_map.get(coords, null)
