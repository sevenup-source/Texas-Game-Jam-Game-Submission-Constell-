extends Node2D
class_name loosestar

var selected = false
var grid_pos: Vector2i = Vector2i.ZERO
var target_global_pos: Vector2 = Vector2.ZERO
var initial_grid_pos: Vector2i = Vector2i.ZERO

@export var grid_container: PuzzleGrid

func _ready() -> void:
	add_to_group("loose_stars")
	target_global_pos = global_position
	if grid_container:
		snap_to_current_grid_pos()
		initial_grid_pos = grid_pos

func _physics_process(delta: float) -> void:
	if selected:
		global_position = lerp(global_position, get_global_mouse_position(), 25.0 * delta)
		look_at(get_global_mouse_position())
	else:
		global_position = lerp(global_position, target_global_pos, 12.0 * delta)
		rotation = lerp_angle(rotation, 0.0, 10.0 * delta)

func snap_to_current_grid_pos() -> void:
	if not grid_container:
		return
	var coords = grid_container.world_to_grid(global_position)
	move_to_grid(coords)

func move_to_grid(new_grid_pos: Vector2i) -> void:
	if not grid_container or selected:
		return
	if new_grid_pos.x < 0 or new_grid_pos.x >= grid_container.width or new_grid_pos.y < 0 or new_grid_pos.y >= grid_container.height:
		return
# Unregister old position and register new position
	grid_container.unregister_loose_star(grid_pos)
	grid_pos = new_grid_pos
	grid_container.register_loose_star(self, grid_pos)
	
	target_global_pos = grid_container.grid_to_world(grid_pos)

func reset_to_start() -> void:
	selected = false
	move_to_grid(initial_grid_pos)

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		selected = true

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		if selected:
			selected = false
			snap_to_current_grid_pos()
