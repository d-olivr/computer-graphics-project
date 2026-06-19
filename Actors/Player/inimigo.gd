extends CharacterBody3D

@export var damage_amount: int = 20
@export var speed: float = 2.0 # Aumentei um pouco para você ver melhor no 3D
@export var castelo: Node3D # IMPORTANTE: Arraste o nó do seu Castelo para cá no Inspector!

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var health_component: HealthComponent = $HealthComponent2

func _physics_process(delta: float) -> void:
	# 1. Aplica a gravidade (Eixo Y - para baixo)
	if not is_on_floor():
		velocity.y -= gravity * delta

	# 2. Lógica de seguir o alvo
	if castelo:
		# Pega a direção do inimigo apontando para o castelo
		var direcao = global_position.direction_to(castelo.global_position)
		
		# Truque 3D: Zeramos o Y da direção para o inimigo não tentar "voar" 
		# em direção ao topo do castelo ou "cavar" se o castelo estiver mais baixo.
		direcao.y = 0 
		direcao = direcao.normalized() # Normaliza de novo para garantir a velocidade certa
		
		# Aplica a velocidade nos eixos X e Z (movimento no chão)
		velocity.x = direcao.x * speed
		velocity.z = direcao.z * speed
	else:
		# Se o castelo não estiver configurado, ele fica parado (mas ainda cai pela gravidade)
		velocity.x = 0
		velocity.z = 0

	move_and_slide()

func _on_hitbox_dano_body_entered(body: Node3D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage_amount)
# Função que a Vânia vai chamar quando acertar o golpe
func take_damage(amount: int) -> void:
	health_component.take_damage(amount)

# Função para quando a vida dele chegar a zero
func _on_health_component_died() -> void:
	print("Inimigo derrotado!")
	queue_free() # Isso faz o inimigo sumir da tela/ser destruído
