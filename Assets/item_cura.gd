extends Area3D

# Define o quanto esse item vai curar a Vânia
@export var quantidade_cura: int = 20

func _ready() -> void:
	# Conecta o sinal de colisão automaticamente via código
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	# Verifica se o objeto que entrou na área tem a função "heal" (se é a Vânia)
	if body.has_method("heal"):
		# Chama a função de cura lá no script player.gd
		body.heal(quantidade_cura)
		
		# Destrói o item de cura da cena
		queue_free()
