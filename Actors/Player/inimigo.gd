extends CharacterBody3D

@export var damage_amount: int = 5
@export var speed: float = 2.0
@export var chase_speed: float = 3.5
@export var detection_distance: float = 1.8
@export var patrol_distance: float = 4.0
@export var flight_height: float = 1.0
@export var float_amplitude: float = 0.5
@export var float_speed: float = 2.0

var start_position: Vector3
var moving_forward := true
var time := 0.0
var is_bouncing := false # Variável para o controle da quicada

@onready var health_component: HealthComponent = $HealthComponent2
@onready var player = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	axis_lock_linear_x = true
	health_component.died.connect(_on_health_component_died)
	start_position = global_position

func _physics_process(delta: float) -> void:
	# 1. Se estiver quicando, apenas processa o recuo e sai da função
	if is_bouncing:
		move_and_slide()
		return
		
	# 2. Se NÃO estiver quicando, processa o movimento normal
	time += delta
	var player_detected := false

	if player:
		if global_position.distance_to(player.global_position) <= detection_distance:
			player_detected = true

	if player_detected:
		var direction = (player.global_position - global_position).normalized()
		velocity.z = direction.z * chase_speed
	else:
		var offset = global_position.z - start_position.z
		if moving_forward:
			velocity.z = speed
			if offset >= patrol_distance: moving_forward = false
		else:
			velocity.z = -speed
			if offset <= -patrol_distance: moving_forward = true

	velocity.x = 0
	var target_y = start_position.y + flight_height + (sin(time * float_speed) * float_amplitude)
	velocity.y = (target_y - global_position.y) * 10.0

	move_and_slide()

func _on_hitbox_dano_body_entered(body: Node3D) -> void:
	if body == player and not is_bouncing:
		player.take_damage(damage_amount)
		is_bouncing = true
		
		# Calcula direção oposta
		var dir_recuo = (global_position.z - player.global_position.z)
		velocity.z = sign(dir_recuo) * 8.0 
		
		move_and_slide()
		
		# Espera 0.3s e libera o movimento
		await get_tree().create_timer(0.3).timeout
		is_bouncing = false

func take_damage(amount: int) -> void:
	health_component.take_damage(amount)

func _on_health_component_died() -> void:
	queue_free()
