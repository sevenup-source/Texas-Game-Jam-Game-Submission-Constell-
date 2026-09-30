extends Node2D
class_name PuzzleManager

enum StarType { PUSH, PULL }

@export var grid: PuzzleGrid
@export var push_star_scene: PackedScene
@export var pull_star_scene: PackedScene

@export var highlight_hover_color := Color(1, 1, 1, 0.25)
@export var highlight_blocked_color := Color(1, 0.2, 0.2, 0.35)

var selected_star_type := StarType.PUSH
var used_x_axes: Array[int] = []
var used_y_axes: Array[int] = []
var placed_stars: Array[PlacedStar] = []

func _process(_delta: float) -> void:
	_update_grid_highlights()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var hover_cell = grid.world_to_grid(get_global_mouse_position())
		if _can_place_at(hover_cell):
			_place_star(hover_cell)

func set_selected_star_type(type: StarType) -> void:
	selected_star_type = type

func _can_place_at(coords: Vector2i) -> bool:
	if coords.x < 0 or coords.x >= grid.width or coords.y < 0 or coords.y >= grid.height:
		return false
	if coords.x in used_x_axes or coords.y in used_y_axes:
		return false
	# Ensure cell isn't occupied by another placed star
	for star in placed_stars:
		if star.grid_pos == coords:
			return false
	return true

func _place_star(coords: Vector2i) -> void:
	var star_scene = push_star_scene if selected_star_type == StarType.PUSH else pull_star_scene
	var star_instance = star_scene.instantiate() as PlacedStar
	
	grid.add_child(star_instance)
	star_instance.initialize(coords, grid)
	
	used_x_axes.append(coords.x)
	used_y_axes.append(coords.y)
	placed_stars.append(star_instance)
	
	star_instance.trigger_effect()

func reset_puzzle() -> void:
	for star in placed_stars:
		if is_instance_valid(star):
			star.queue_free()
	placed_stars.clear()
	used_x_axes.clear()
	used_y_axes.clear()
	
	for loose_star in get_tree().get_nodes_in_group("loose_stars"):
		if loose_star.has_method("reset_to_start"):
			loose_star.reset_to_start()

func _update_grid_highlights() -> void:
	if not grid:
		return
		
	var hover_coords = grid.world_to_grid(get_global_mouse_position())
	
	for x in range(grid.width):
		for y in range(grid.height):
			var cell = grid.get_cell_node(Vector2i(x, y))
			if not cell:
				continue
				
			var is_blocked = (x in used_x_axes) or (y in used_y_axes)
			var is_hover_crosshair = (x == hover_coords.x or y == hover_coords.y) and hover_coords.x >= 0 and hover_coords.x < grid.width and hover_coords.y >= 0 and hover_coords.y < grid.height
			
			if is_blocked:
				cell.modulate = highlight_blocked_color
			elif is_hover_crosshair:
				cell.modulate = highlight_hover_color
			else:
				cell.modulate = Color.WHITE
