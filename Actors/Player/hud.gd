extends CanvasLayer

@onready var health_bar: ProgressBar = $HealthBar
@onready var life_text: Label = $TextoVida # Puxamos a referência do texto aqui!
# Função que será chamada sempre que a vida mudar
func update_health(current_health: int, max_health: int) -> void:
	health_bar.max_value = max_health
	health_bar.value = current_health
# Atualiza o texto na tela transformando os números em String (texto)
	life_text.text = "Vida: " + str(current_health) + " / " + str(max_health)
