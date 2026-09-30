extends RigidBody2D
class_name PushableCrate

func _ready() -> void:
	add_to_group("crates")
	lock_rotation = true
	linear_damp = 5.0
	ccd_mode = RigidBody2D.CCD_MODE_CAST_RAY
