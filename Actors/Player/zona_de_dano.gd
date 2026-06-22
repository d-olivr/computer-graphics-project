extends Area3D

# Quanto de dano essa área vai causar
@export var damage_amount: int = 100

func _on_body_entered(body: Node3D) -> void:
	# O "body" é qualquer coisa com física que entrou na área
	# Nós verificamos se esse corpo possui a função "take_damage" que criamos antes
	if body.has_method("take_damage"):
		body.take_damage(damage_amount)
