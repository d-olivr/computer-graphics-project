extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 5.5

@onready var health_component: HealthComponent = $HealthComponent
@onready var visual_node: Node3D = $VampiraNV
@onready var area_ataque: Area3D = $AreaAtaque
@onready var hud: CanvasLayer = $HUD

# --- VARIÁVEIS DE ILUMINAÇÃO ---
@export var luz_lanterna: Node3D
@export var velocidade_luz: float = 5.0 # Controla a rapidez com que a luz segue a Vânia

@onready var anim_player: AnimationPlayer = $VampiraNV/AnimationPlayer

var spawn_position: Vector3

func _ready() -> void:
	axis_lock_linear_x = true

	# Guarda a posição inicial para respawn
	spawn_position = global_position

	health_component.health_changed.connect(hud.update_health)
	health_component.died.connect(_on_player_died)

	hud.update_health(
		health_component.current_health,
		health_component.max_health
	)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	

	# Pulo
	if Input.is_action_just_pressed("ui_select") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Ataque
	if Input.is_action_just_pressed("atacar"):
		atacar()

	var input_dir := Input.get_vector(
		"ui_left",
		"ui_right",
		"ui_up",
		"ui_down"
	)

	var direction := (
		transform.basis *
		Vector3(input_dir.x, 0, input_dir.y)
	).normalized()

	if direction:
		velocity.z = direction.z * SPEED

		if direction.z > 0:
			visual_node.rotation.y = lerp_angle(
				visual_node.rotation.y,
				PI / 2,
				0.2
			)
		elif direction.z < 0:
			visual_node.rotation.y = lerp_angle(
				visual_node.rotation.y,
				-PI / 2,
				0.2
			)
	else:
		velocity.z = move_toward(
			velocity.z,
			0,
			SPEED
		)

	#velocity.x = 0
	
	# --- NOVO: CONTROLE DE ANIMAÇÕES ---
	# 1. Verificamos se a animação de ataque está tocando
	var is_attacking = anim_player.current_animation == "animacoes/chutar" and anim_player.is_playing()
	
	# 2. Só mudamos a animação de movimento se ELA NÃO ESTIVER ATACANDO
	if not is_attacking:
		if not is_on_floor():
			anim_player.play("animacoes/pular") # Troque pelo nome exato da sua animação de pulo
		elif direction != Vector3.ZERO:
			anim_player.play("animacoes/correr") # Troque pelo nome exato da sua animação de corrida
		else:
			anim_player.play("animacoes/idle") # Troque pelo nome exato da sua animação de ficar parada
	# -----------------------------------

	move_and_slide()

func atacar() -> void:
	# NOVO: Toca a animação de ataque assim que a função é chamada
	anim_player.play("animacoes/chutar") # Troque pelo nome exato da sua animação de ataque
	var corpos_acertados = area_ataque.get_overlapping_bodies()

	for corpo in corpos_acertados:
		if corpo.has_method("take_damage") and corpo != self:
			corpo.take_damage(40)
			print("Vânia acertou: ", corpo.name)

func heal(amount: int) -> void:
	health_component.heal(amount)

func take_damage(amount: int) -> void:
	health_component.take_damage(amount)

func _process(delta: float) -> void:
	# Verifica se atribuímos uma luz no Inspetor
	if luz_lanterna:
		# Define a posição onde a luz deve tentar chegar (ex: 1.5 metros acima do chão)
		var posicao_alvo = global_position + Vector3(0, 1.5, 0)
		
		# O segredo da suavização (lerp): desliza a posição atual até ao alvo
		luz_lanterna.global_position = luz_lanterna.global_position.lerp(posicao_alvo, velocidade_luz * delta)



func _on_player_died() -> void:
	print("Vânia morreu!")

	# Respawn
	global_position = spawn_position
	velocity = Vector3.ZERO

	# Recupera a vida
	health_component.current_health = health_component.max_health

	hud.update_health(
		health_component.current_health,
		health_component.max_health
	)

	print("Respawn realizado!")
