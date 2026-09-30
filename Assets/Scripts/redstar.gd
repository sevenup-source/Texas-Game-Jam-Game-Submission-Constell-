extends Sprite2D


var selected = false
var grid_pos: Vector2i = Vector2i.ZERO
var target_global_pos: Vector2 = Vector2.ZERO

@export var grid_container: GridContainer

func _ready() -> void:
	# Default target position to current starting global position
	target_global_pos = global_position
	
	# Automatically snap to grid if grid_container is assigned
	if grid_container:
		snap_to_current_grid_pos()

func _physics_process(delta: float) -> void:
	if selected:
		# Follow mouse directly while dragging
		global_position = lerp(global_position, get_global_mouse_position(), 25.0 * delta)
		look_at(get_global_mouse_position())
	else:
		# Smoothly slide toward target grid slot when not selected
		global_position = lerp(global_position, target_global_pos, 12.0 * delta)
		rotation = lerp_angle(rotation, 0.0, 10.0 * delta)

# Calculate grid coordinate based on current physical location
func snap_to_current_grid_pos() -> void:
	if not grid_container:
		return
		
	var cell_w: float = grid_container.cellWidth + grid_container.borderSize
	var cell_h: float = grid_container.cellHeight + grid_container.borderSize
	
	# Convert local offset relative to grid top-left
	var local_pos = global_position - grid_container.global_position
	
	var gx = int(floor(local_pos.x / cell_w))
	var gy = int(floor(local_pos.y / cell_h))
	
	# Check if inside grid bounds
	if gx >= 0 and gx < grid_container.width and gy >= 0 and gy < grid_container.height:
		move_to_grid(Vector2i(gx, gy))

# Move star to a specific grid coordinate
func move_to_grid(new_grid_pos: Vector2i) -> void:
	if not grid_container or selected:
		return
		
	# Verify grid boundary condition
	if new_grid_pos.x < 0 or new_grid_pos.x >= grid_container.width or new_grid_pos.y < 0 or new_grid_pos.y >= grid_container.height:
		return
		
	grid_pos = new_grid_pos
	
	# Offset calculation including grid global position and cell spacing
	var step_x: float = grid_container.cellWidth + grid_container.borderSize
	var step_y: float = grid_container.cellHeight + grid_container.borderSize
	var center_offset := Vector2(grid_container.cellWidth / 2.0, grid_container.cellHeight / 2.0)
	
	target_global_pos = grid_container.global_position + Vector2(grid_pos.x * step_x, grid_pos.y * step_y) + center_offset

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		selected = true

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		if selected:
			selected = false
			snap_to_current_grid_pos()
