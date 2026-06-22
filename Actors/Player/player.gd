extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 5.5

@onready var health_component: HealthComponent = $HealthComponent
@onready var visual_node: Node3D = $VisualVampira
@onready var area_ataque: Area3D = $AreaAtaque
@onready var hud: CanvasLayer = $HUD

var spawn_position: Vector3

func _ready() -> void:
	axis_lock_linear_x = true

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

	# PULO: Espaço (ui_select)
	if Input.is_action_just_pressed("ui_select") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# ATAQUE: Agora usa a tecla P (Ação 'atacar' configurada no Input Map)
	if Input.is_action_just_pressed("atacar"):
		atacar()

	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.z = direction.z * SPEED
		if direction.z > 0:
			visual_node.rotation.y = lerp_angle(visual_node.rotation.y, PI / 2, 0.2)
		elif direction.z < 0:
			visual_node.rotation.y = lerp_angle(visual_node.rotation.y, -PI / 2, 0.2)
	else:
		velocity.z = move_toward(velocity.z, 0, SPEED)

	velocity.x = 0
	move_and_slide()

func atacar() -> void:
	# O sistema de ataque ignora itens porque itens não possuem 'take_damage'
	var corpos_acertados = area_ataque.get_overlapping_bodies()
	for corpo in corpos_acertados:
		if corpo.has_method("take_damage") and corpo != self:
			corpo.take_damage(40)
			print("Vânia acertou: ", corpo.name)
func heal(amount: int) -> void:
	health_component.current_health += amount

	if health_component.current_health > health_component.max_health:
		health_component.current_health = health_component.max_health

	hud.update_health(
		health_component.current_health,
		health_component.max_health
	)
func take_damage(amount: int) -> void:
	health_component.take_damage(amount)

func _on_player_died() -> void:
	print("Vânia morreu!")

	global_position = spawn_position

	health_component.current_health = health_component.max_health

	hud.update_health(
		health_component.current_health,
		health_component.max_health
	)

	velocity = Vector3.ZERO
