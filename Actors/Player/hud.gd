extends CanvasLayer

@onready var health_bar: TextureProgressBar = $HealthBar
@onready var life_text: Label = $TextoVida # Puxamos a referência do texto aqui!
# Função que será chamada sempre que a vida mudar
func update_health(current_health: int, max_health: int) -> void:
	health_bar.max_value = max_health
	health_bar.value = current_health
# Atualiza o texto na tela transformando os números em String (texto)
	life_text.text = str(current_health) + "%"
