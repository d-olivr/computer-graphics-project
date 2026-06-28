extends MeshInstance3D

@export var player: Node3D

func _process(delta):
	var mat := get_active_material(0) as ShaderMaterial
	if mat and player:
		mat.set_shader_parameter("player_position", player.global_position)
