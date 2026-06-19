class_name HealthComponent
extends Node

# Sinais para avisar outros sistemas quando algo acontecer
signal health_changed(current_health: int, max_health: int)
signal died

# O @export permite que você mude a vida máxima direto no painel do Inspetor
@export var max_health: int = 100
var current_health: int

func _ready() -> void:
	# A vida inicial começa no máximo
	current_health = max_health

func take_damage(amount: int) -> void:
	current_health -= amount
	# Garante que a vida não fique negativa
	current_health = max(current_health, 0)
	
	# Emite o sinal para atualizar barras de vida ou ativar o "Efeito de Dano"
	health_changed.emit(current_health, max_health)
	
	if current_health == 0:
		died.emit()

func heal(amount: int) -> void:
	current_health += amount
	# Garante que a vida não passe do limite máximo
	current_health = min(current_health, max_health)
	
	health_changed.emit(current_health, max_health)
