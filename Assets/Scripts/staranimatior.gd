extends Node2D

@export var animation_player: AnimationPlayer
@export var sprite: Sprite2D

func _process(delta):
		animation_player.play("idle")
