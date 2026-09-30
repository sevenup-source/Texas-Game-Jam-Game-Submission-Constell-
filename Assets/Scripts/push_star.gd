extends PlacedStar
class_name PushStar

const DIAGONALS = [Vector2i(-1, -1), Vector2i(1, -1), Vector2i(-1, 1), Vector2i(1, 1)]

func trigger_effect() -> void:
	if not grid_ref:
		return
		
	for dir in DIAGONALS:
		var check_cell: Vector2i = grid_pos + dir
		var star := grid_ref.get_loose_star_at(check_cell)
		
		if star:
			var target_cell : Vector2i = check_cell + dir
			star.move_to_grid(target_cell)
