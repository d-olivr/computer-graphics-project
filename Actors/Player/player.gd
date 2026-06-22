extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 5.5
@onready var health_component: HealthComponent = $HealthComponent
@onready var visual_node: Node3D = $VisualVampira
@onready var barra_vida: ProgressBar = %BarraVida
@onready var area_ataque: Area3D = $AreaAtaque

# --- VARIÁVEIS DE CONTROLE DE VIDA ---
@export var max_health: int = 100
var current_health: int

# --- HUD ---
@onready var hud: CanvasLayer = $HUD

func _ready() -> void:
	# Trava o eixo X! A Vânia nunca vai escorregar para os lados.
	axis_lock_linear_x = true
	
	health_component.health_changed.connect(hud.update_health)
	health_component.died.connect(_on_player_died)
	hud.update_health(health_component.current_health, health_component.max_health)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		# Aplica a velocidade APENAS no eixo Z
		velocity.z = direction.z * SPEED

		# Vira o modelo 3D baseado na direção do eixo Z
		if direction.z > 0:
			visual_node.rotation.y = lerp_angle(visual_node.rotation.y, PI / 2, 0.2)
		elif direction.z < 0:
			visual_node.rotation.y = lerp_angle(visual_node.rotation.y, -PI / 2, 0.2)
	else:
		velocity.z = move_toward(velocity.z, 0, SPEED)

	# Zera explicitamente o eixo X para manter estritamente no seu formato de câmera
	velocity.x = 0

	move_and_slide()
	
# --- FUNÇÃO DE CURA ---
func heal(amount: int):
	current_health += amount
	
	if current_health > max_health:
		current_health = max_health
		
	print("Vânia curada! Vida atual: ", current_health)

func take_damage(amount: int) -> void:
	health_component.take_damage(amount)
	print("Vânia recebeu dano! Vida atual: ", health_component.current_health)

@warning_ignore("shadowed_global_identifier", "unused_parameter")
func _on_health_changed(current: int, max: int) -> void:
	# Preparando o terreno para a barra de vida
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("TESTE 1: O jogo sentiu o clique do mouse!")
		atacar()

func atacar() -> void:
	var corpos_acertados = area_ataque.get_overlapping_bodies()
	
	for corpo in corpos_acertados:
		if corpo.has_method("take_damage") and corpo != self:
			corpo.take_damage(40)
			print("Vânia acertou um golpe no monstro!")

func _on_player_died() -> void:
	print("Fim de jogo!")
