extends PlacedStar
class_name PullStar

const DIAGONALS = [Vector2i(-1, -1), Vector2i(1, -1), Vector2i(-1, 1), Vector2i(1, 1)]

func trigger_effect() -> void:
	if not grid_ref:
		return
		
	for dir in DIAGONALS:
		var check_cell : Vector2i = grid_pos + (dir * 2)
		var star := grid_ref.get_loose_star_at(check_cell)
		
		if star:
			# Pulls 1 cell closer (from 2 diagonals out to 1 diagonal out)
			var target_cell : Vector2i = grid_pos + dir
			star.move_to_grid(target_cell)
