extends Area3D

# Quanto de dano essa área vai causar
@export var damage_amount: int = 100
var checkpoint_manager
var player

func _ready() -> void:
	checkpoint_manager = get_tree().get_first_node_in_group("Singleton")
	player = get_tree().get_first_node_in_group("Player")

func _on_body_entered(body: Node3D) -> void:
	# O "body" é qualquer coisa com física que entrou na área
	# Nós verificamos se esse corpo possui a função "take_damage" que criamos antes
	if body.is_in_group("Player"):
		KillPlayer(body)

func KillPlayer(body):
	if body.has_method("take_damage"):
		body.take_damage(damage_amount)
		player.position = checkpoint_manager.last_location
