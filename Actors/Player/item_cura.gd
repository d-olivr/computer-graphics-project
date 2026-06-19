extends Area3D

@export var heal_amount: int = 30

func _on_body_entered(body: Node3D) -> void:
	# Verifica se quem encostou tem a função de curar
	if body.has_method("heal"):
		body.heal(heal_amount)
		# Destrói o item para ele não curar infinitamente
		queue_free()
