extends Node3D

func _ready():
	pass

func _input(event):
	if Input.is_action_pressed("random"):
		$Environment.rotate_y(0.075)

	if Input.is_action_pressed("lighting"):
		$Environment/AnimationPlayer.speed_scale = 2.0
		await get_tree().create_timer(0.5).timeout
		$Environment/AnimationPlayer.speed_scale = 0.01
